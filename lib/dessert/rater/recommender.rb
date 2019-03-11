module Dessert
  module Rater
    module Recommender
      def nearest_neighbors(klass)
        key = Dessert::Helpers::RedisKeyManager.signiture_key_for(klass: klass, user_id: id)
        signitures = JSON.parse(Dessert.redis.get(key) || '[]')

        secondary_index_keys = signitures.map.with_index.to_a.map(&:reverse).map do |signiture_with_index|
          Dessert::Helpers::RedisKeyManager.secondary_index_key_for(klass: klass, signiture_with_index: signiture_with_index)
        end

        return [] if secondary_index_keys.empty?

        Dessert.redis.mget(secondary_index_keys)
          .map { |value| JSON.parse(value || '[]') }
          .flatten
          .group_by(&:itself)
          .transform_values(&:count)
          .sort_by { |key, value| -value }
          .slice(1..Dessert.config.max_neighbors)
          .map(&:first)
      end

      def recommended_for(klass:, offset:, limit:)
        users = nearest_neighbors(klass)
        keys = users.map do |user|
          Dessert::Helpers::RedisKeyManager.liked_key_for(klass: klass, user_id: user)
        end

        return [] if keys.empty?

        Dessert.redis.sunion(keys) - likes(klass) - hides(klass)
      end
    end
  end
end
