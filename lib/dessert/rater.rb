require 'dessert/rater/liker'
require 'dessert/rater/hider'
require 'dessert/rater/recommender'

module Dessert
  module Rater
    def self.included(base)
      base.class_eval do
        include Liker
        include Hider
        include Recommender
        include Hooks

        define_hooks :before_like, :after_like, :after_unlike

        before_like :unhide
        after_like :reconcile_signitures
        after_unlike :replace_signitures

        private

        def reconcile_signitures(item)
          update_signitures(item) do |old_signitures|
            [*(0...100)].map do |i|
              [Dessert::Helpers::MinHash.get(i, item.id), old_signitures[i]].compact.min
            end
          end
        end

        def replace_signitures(item)
          cached_likes = likes
          update_signitures(item) do |old_signitures|
            [*(0...100)].map do |i|
              cached_likes.map do |like|
                Dessert::Helpers::MinHash.get(i, like)
              end.min
            end
          end
        end

        def update_signitures(item)
          key = Dessert::Helpers::RedisKeyManager.signiture_key_for(item: item, user_id: id)

          old_signitures = JSON.parse(Dessert.redis.get(key) || '[]')
          new_signitures = yield old_signitures

          Dessert.redis.set(key, new_signitures.to_json)

          old_signitures_with_index = old_signitures.map.with_index.to_a.map(&:reverse)
          new_signitures_with_index = new_signitures.map.with_index.to_a.map(&:reverse)

          add_secondary_index(item: item, signitures_with_index: new_signitures_with_index - old_signitures_with_index)
          remove_secondary_index(item: item, signitures_with_index: old_signitures_with_index - new_signitures_with_index)
        end

        def add_secondary_index(item:, signitures_with_index:)
          keys = signitures_with_index.map do |signiture_with_index|
            Dessert::Helpers::RedisKeyManager.secondary_index_key_for(item: item, signiture_with_index: signiture_with_index)
          end

          return if keys.empty?

          secondary_indices = Dessert.redis.mget(keys).map.with_index do |secondary_index, i|
            JSON.parse(secondary_index || '[]') << id
          end.map(&:to_json)

          Dessert.redis.mset(keys.zip(secondary_indices).flatten)
        end

        def remove_secondary_index(item:, signitures_with_index:)
          keys = signitures_with_index.map do |signiture_with_index|
            Dessert::Helpers::RedisKeyManager.secondary_index_key_for(item: item, signiture_with_index: signiture_with_index)
          end

          return if keys.empty?

          secondary_indices = Dessert.redis.mget(keys).map.with_index do |secondary_index, i|
            JSON.parse(secondary_index || '[]').tap do |value|
              value.delete(id)
            end
          end.map(&:to_json)

          Dessert.redis.mset(keys.zip(secondary_indices).flatten)
        end
      end
    end
  end
end
