require 'guard'
require 'guard/guard'
require 'guard/rails/runner'
require 'rbconfig'

module Guard
  class Rails < ::Guard::Guard
    attr_reader :options, :runner

    def initialize(watchers = [], options = {})
      super
      @options = {
        :port => 3000,
        :environment => 'development',
        :start_on_start => true,
        :force_run => false
      }.merge(options)

      @runner = Guard::RailsRunner.new(options)
    end

    def start
      UI.info "Guard::Rails restarting app on port #{options[:port]} using #{options[:environment]} environment."
      run_all if options[:start_on_start]
    end

    def run_all
      UI.info "Restarting Rails"
      Notifier.notify("Rails restarting on port #{options[:port]} in #{options[:environment]} environment...", :title => "Restarting Rails...", :image => :pending)
      runner.restart
      UI.info "Rails restarted, pid #{File.read(pid_file)}"
      Notifier.notify("Rails restarted on port #{options[:port]}.", :title => "Rails restarted!", :image => :success)
    end

    def stop
      Notifier.notify("Until next time...", :title => "Rails shutting down.", :image => :pending)
      runner.stop
    end

    def run_on_change(paths)
      run_all
    end
  end
end

