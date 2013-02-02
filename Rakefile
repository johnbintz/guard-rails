include Rake::DSL if defined?(Rake::DSL)

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
    prefix = "rvm 1.8.7,1.9.2,ree,1.9.3 do"
    system %{#{prefix} bundle}
    system %{#{prefix} bundle exec rake spec}
    exit $?.exitstatus if $?.exitstatus != 0
  end
end

task :default => 'spec:platforms'
