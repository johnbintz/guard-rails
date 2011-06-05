require 'bundler'
Bundler::GemHelper.install_tasks

desc "Run on this Ruby"
task :spec do
    system %{rspec spec}
    exit $?.exitstatus
end

namespace :spec do
  desc "Run on three Rubies"
  task :platforms do
    current = %x{rvm-prompt v}
    
    fail = false
    %w{1.8.7 1.9.2 ree}.each do |version|
      puts "Switching to #{version}"
      system %{rvm #{version}}
      system %{rspec spec}
      if $?.exitstatus != 0
        fail = true
        break
      end
    end

    system %{rvm #{current}}

    exit (fail ? 1 : 0)
  end
end

task :default => 'spec:platforms'
