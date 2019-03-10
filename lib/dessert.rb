require 'json'
require 'prime'
require 'redis'
require 'hooks'

require 'dessert/configuration'
require 'dessert/helpers'
require 'dessert/rater'

module Dessert
  class << self
    def redis
      config.redis
    end
  end
end
