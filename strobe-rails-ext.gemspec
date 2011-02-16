# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "strobe-rails-ext"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Carl Lerche"]
  s.email       = ["carl@strobecorp.com"]
  s.homepage    = "http://rubygems.org/gems/strobe-rails-ext"
  s.summary     = "Some extensions to rails that we like to use"
  s.description = ""

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "strobe-rails-ext"

  # s.add_dependency "activesupport", "~> 3.0.0"
  #   activesupport is implicitly required by activemodel
  #   having a ~> dependency on activesupport here as well
  #   seems to thoroughly confuse the hell out of rubygems.
  s.add_dependency "actionpack",    "< 3.2.0", ">= 3.0.0"
  s.add_dependency "activesupport", "< 3.2.0", ">= 3.0.0"

  s.files        = Dir["lib/**/*.rb"]
  s.require_path = 'lib'
end
