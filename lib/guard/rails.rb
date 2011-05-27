require 'guard'
require 'guard/guard'

module Guard
  class Rails < ::Guard::Guard
    attr_reader :options

    def initialize(watchers = [], options = {})
      super
      @options = { :port => 3000, :environment => 'development', :start_on_start => true }.merge(options)
    end

    def start
      UI.info "Guard::Rails restarting app on port #{options[:port]} using #{options[:environment]} environment."
      run_all if options[:start_on_start]
    end

    def run_all
      Notifier.notify("Rails restarting on port #{options[:port]} in #{options[:environment]}", :title => "Restarting Rails...", :image => :pending)
      stop_rails ; start_rails
    end

    def stop
      Notifier.notify("Until next time...", :title => "Rails shutting down.", :image => :pending)
      stop_rails
    end

    def run_on_change(paths)
      run_all
    end

    private
    def pid_file
      File.expand_path("tmp/pids/#{options[:environment]}.pid")
    end

    def start_rails
      system %{sh -c 'rails s -d -e #{options[:environment]} -p #{options[:port]} --pid #{pid_file}'}
    end

    def stop_rails
      if File.file?(pid_file)
        system %{kill -INT #{File.read(pid_file).strip}}
      end
    end
  end
end

