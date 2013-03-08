source "http://rubygems.org"
# source 'http://ruby.taobao.org'

# Specify your gem's dependencies in guard-rails.gemspec
gemspec
gem 'rake'
gem 'fakefs', :require => nil
gem 'guard'
gem 'guard-bundler'
gem 'guard-rspec'

gem 'rb-fsevent', '>= 0.3.9'
gem 'rb-inotify', '>= 0.5.1'

# Notification System
gem 'terminal-notifier-guard', :require => RUBY_PLATFORM.downcase.include?("darwin") ? 'terminal-notifier-guard' : nil
gem 'libnotify', :require => RUBY_PLATFORM.downcase.include?("linux") ? 'libnotify' : nil
