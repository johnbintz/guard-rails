source "http://rubygems.org"

# Specify your gem's dependencies in guard-rails.gemspec
gemspec
gem 'rake'
gem 'fakefs', :require => nil
gem 'guard'
gem 'guard-rspec'
gem 'mocha', '~> 0.12.3'

require 'rbconfig'
if RbConfig::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent', '>= 0.3.9'
  gem 'growl', '~> 1.0.3'
end
if RbConfig::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '>= 0.5.1'
  gem 'libnotify', '~> 0.1.3'
end

