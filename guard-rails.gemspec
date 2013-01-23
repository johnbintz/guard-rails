$:.push File.expand_path("../lib", __FILE__)
require "guard/rails/version"

Gem::Specification.new do |s|
  s.name        = "guard-rails"
  s.version     = GuardRails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Bintz", "Wanzhang Sheng"]
  s.email       = ["john@coswellproductions.com", "Ranmocy@gmail.com"]
  s.homepage    = "https://github.com/ranmocy/guard-rails"
  s.summary     = %q{Guard your Rails to always be there.}
  s.description = %q{Restart Rails when things change in your app}

  s.rubyforge_project = "guard-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'guard', '>= 0.2.2'

  s.add_development_dependency 'rspec', '>= 2.6.0'
  s.add_development_dependency 'mocha', '>= 0.13.1'
end
