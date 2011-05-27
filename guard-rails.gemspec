# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/rails/version"

Gem::Specification.new do |s|
  s.name        = "guard-rails"
  s.version     = GuardRails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Bintz"]
  s.email       = ["john@coswellproductions.com"]
  s.homepage    = ""
  s.summary     = %q{Restart Rails when things change in your app}
  s.description = %q{Restart Rails when things change in your app}

  s.rubyforge_project = "guard-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'guard', '>= 0.2.2'
end
