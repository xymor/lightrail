# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "strobe-rails-ext"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Carl Lerche", "José Valim"]
  s.email       = ["carl@strobecorp.com", "jose.valim@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/strobe-rails-ext"
  s.summary     = "Some extensions to rails that we like to use"
  s.description = ""

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "strobe-rails-ext"

  # This depends on ActiveSupport and ActionPack for us.
  s.add_dependency "railties",    "< 3.2.0", ">= 3.0.3"

  s.files        = Dir["lib/**/*.rb"]
  s.require_path = 'lib'

  # Provide a rails binary so we don't need to depend
  # on the rails gem in strobe internal projects.
  s.bindir             = 'bin'
  s.executables        = ['rails']
end
