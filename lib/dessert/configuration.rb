module Dessert
  class Configuration
    attr_accessor :redis
    attr_accessor :redis_namespace
    attr_accessor :max_neighbors
    attr_accessor :signiture_size
    attr_accessor :minhash_mod

    def initialize
      @redis = Redis.new(host: 'localhost', port: 6379)
      @redis_namespace = 'dessert'
      @max_neighbors = 5
      @signiture_size = 100
      @minhash_mod = 1009
    end
  end

  class << self
    def configure
      @config ||= Configuration.new
      yield @config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
