lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dessert/version'

Gem::Specification.new do |spec|
  spec.name          = 'dessert'
  spec.version       = Dessert::VERSION
  spec.authors       = ['Injung Chung']
  spec.email         = ['mu29@yeoubi.net']

  spec.summary       = 'A lightweight recommendation engine for Ruby apps using Redis'
  spec.homepage      = 'https://github.com/mu29/dessert'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'prime', '~> 0.1.0'
  spec.add_dependency 'hooks', '~> 0.4.1'
  spec.add_dependency 'redis', '~> 4.1.0'

  spec.add_development_dependency 'rake', '~> 12.3.1'
end
