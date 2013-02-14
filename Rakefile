include Rake::DSL if defined?(Rake::DSL)
RVM_PREFIX = "rvm 1.8.7@guard-rails,1.9.3-p327@guard-rails,2.0.0@guard-rails do"

require 'bundler'
Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'

desc 'Push everywhere!'
task :publish do
  system %{git push origin}
  system %{git push guard}
  system %{git push gitcafe}
end

RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc "Run on three Rubies"
  task :platforms do
    system %{#{RVM_PREFIX} bundle}
    system %{#{RVM_PREFIX} bundle exec rake spec}
    exit $?.exitstatus if $?.exitstatus != 0
  end
end

task :default => 'spec:platforms'
