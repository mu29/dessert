module Dessert
  module Rater
    module Liker
      def like(item)
        return if like?(item)

        run_hook(:before_like, item)
        key = Dessert::Helpers::RedisKeyManager.liked_key_for(item: item, user_id: id)
        Dessert.redis.sadd(key, item.id)
        run_hook(:after_like, item)
      end

      def unlike(item)
        return unless like?(item)

        key = Dessert::Helpers::RedisKeyManager.liked_key_for(item: item, user_id: id)
        Dessert.redis.srem(key, item.id)
        run_hook(:after_unlike, item)
      end

      def like?(item)
        key = Dessert::Helpers::RedisKeyManager.liked_key_for(item: item, user_id: id)
        Dessert.redis.sismember(key, item.id)
      end

      def likes(klass)
        key = Dessert::Helpers::RedisKeyManager.liked_key_for(klass: klass, user_id: id)
        Dessert.redis.smembers(key)
      end
    end
  end
end
