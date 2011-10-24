require 'guard'
require 'guard/guard'
require 'guard/rails/runner'
require 'rbconfig'

module Guard
  class Rails < ::Guard::Guard
    attr_reader :options, :runner

    DEFAULT_OPTIONS = {
        :port => 3000,
        :environment => 'development',
        :start_on_start => true,
        :force_run => false,
        :timeout => 20,
        :server => nil,
        :debugger => false
      }

    def initialize(watchers = [], options = {})
      super
      @options = DEFAULT_OPTIONS.merge(options)

      @runner = RailsRunner.new(@options)
    end

    def start
      server = options[:server] ? "#{options[:server]} and " : ""
      UI.info "Guard::Rails will now restart your app on port #{options[:port]} using #{server}#{options[:environment]} environment."
      reload if options[:start_on_start]
    end

    def reload
      UI.info "Restarting Rails..."
      Notifier.notify("Rails restarting on port #{options[:port]} in #{options[:environment]} environment...", :title => "Restarting Rails...", :image => :pending)
      if runner.restart
        UI.info "Rails restarted, pid #{runner.pid}"
        Notifier.notify("Rails restarted on port #{options[:port]}.", :title => "Rails restarted!", :image => :success)
      else
        UI.info "Rails NOT restarted, check your log files."
        Notifier.notify("Rails NOT restarted, check your log files.", :title => "Rails NOT restarted!", :image => :failed)
      end
    end

    def stop
      Notifier.notify("Until next time...", :title => "Rails shutting down.", :image => :pending)
      runner.stop
    end

    def run_on_change(paths)
      reload
    end
  end
end

