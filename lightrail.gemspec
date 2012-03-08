# encoding: utf-8
require File.expand_path('../lib/lightrail/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'lightrail'
  gem.version     = Lightrail::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['Carl Lerche', 'José Valim', 'Tony Arcieri']
  gem.email       = ['me@carllerche.com', 'jose.valim@gmail.com', 'tony.arcieri@gmail.com']
  gem.homepage    = 'http://github.com/tarcieri/lightrail'
  gem.summary     = 'Slim Rails stack for JSON services'
  gem.description = 'Lightrail slims Rails down to the bare essentials great JSON web services crave'
  gem.files        = Dir["lib/**/*.rb"]
  gem.require_path = 'lib'
  gem.bindir       = 'bin'
  gem.executables  = %w(lightrail)

  # This depends on ActiveSupport and ActionPack for us.
  gem.add_dependency 'railties', '~> 3.2.0'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
