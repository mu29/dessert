module Dessert
  module Helpers
    module RedisKeyManager
      class << self
        def liked_key_for(klass: nil, item: nil, user_id:)
          key_for(type: 'liked', item: item, klass: klass, id: user_id)
        end

        def hidden_key_for(klass: nil, item: nil, user_id:)
          key_for(type: 'hidden', item: item, klass: klass, id: user_id)
        end

        def signiture_key_for(klass: nil, item: nil, user_id:)
          key_for(type: 'signiture', item: item, klass: klass, id: user_id)
        end

        def secondary_index_key_for(klass: nil, item: nil, signiture_with_index:)
          key_for(type: 'secondary-index', item: item, klass: klass, id: signiture_with_index.join('-'))
        end

        private

        def key_for(type:, item:, klass:, id:)
          [Dessert.config.redis_namespace, type, (klass || item.class).to_s.downcase, id].compact.join(':')
        end
      end
    end
  end
end
