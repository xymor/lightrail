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

  # This depends on ActiveSupport and ActionPack for us.
  gem.add_dependency 'railties', '~> 3.2.0'

  gem.files        = Dir["lib/**/*.rb"]
  gem.require_path = 'lib'

  # Provide a rails binary so we don't need to depend
  # on the rails gem in strobe internal projects.
  gem.bindir       = 'bin'
  gem.executables  = %w(lightrail)
end
