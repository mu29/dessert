module Dessert
  module Rater
    module Hider
      def hide(item)
        return if hide?(item)

        key = Dessert::Helpers::RedisKeyManager.hidden_key_for(item: item, user_id: id)
        Dessert.redis.sadd(key, item.id)
      end

      def unhide(item)
        return unless hide?(item)

        key = Dessert::Helpers::RedisKeyManager.hidden_key_for(item: item, user_id: id)
        Dessert.redis.srem(key, item.id)
      end

      def hide?(item)
        key = Dessert::Helpers::RedisKeyManager.hidden_key_for(item: item, user_id: id)
        Dessert.redis.sismember(key, item.id)
      end

      def hides(klass)
        key = Dessert::Helpers::RedisKeyManager.hidden_key_for(klass: klass, user_id: id)
        Dessert.redis.smembers(key)
      end
    end
  end
end
