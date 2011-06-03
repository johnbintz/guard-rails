require 'bundler'
Bundler::GemHelper.install_tasks

namespace :spec do
  desc "Run on three Rubies"
  task :platforms do
    current = %x{rvm-prompt v}
    
    %w{1.8.7 1.9.2 ree}.each do |version|
      puts "Switching to #{version}"
      system %{rvm #{version}}
      system %{bundle exec rspec spec}
      break if $?.exitstatus != 0
    end

    system %{rvm #{current}}
  end
end
