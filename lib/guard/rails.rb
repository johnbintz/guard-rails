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
        :timeout => 30,
        :server => nil,
        :debugger => false,
        :pid_file => nil,
        :zeus => false,
      }

    def initialize(watchers = [], options = {})
      super
      @options = DEFAULT_OPTIONS.merge(options)

      @runner = RailsRunner.new(@options)
    end

    def start
      server = options[:server] ? "#{options[:server]} and " : ""
      UI.info "Guard::Rails will now restart your app on port #{options[:port]} using #{server}#{options[:environment]} environment."
      reload("start") if options[:start_on_start]
    end

    def reload(action = "restart")
      action_cap = action.capitalize
      UI.info "#{action_cap}ing Rails..."
      Notifier.notify("Rails #{action}ing on port #{options[:port]} in #{options[:environment]} environment...", :title => "#{action_cap}ing Rails...", :image => :pending)
      if runner.restart
        UI.info "Rails #{action}ed, pid #{runner.pid}"
        Notifier.notify("Rails #{action}ed on port #{options[:port]}.", :title => "Rails #{action}ed!", :image => :success)
      else
        UI.info "Rails NOT #{action}ed, check your log files."
        Notifier.notify("Rails NOT #{action}ed, check your log files.", :title => "Rails NOT #{action}ed!", :image => :failed)
      end
    end

    def stop
      Notifier.notify("Until next time...", :title => "Rails shutting down.", :image => :pending)
      runner.stop
    end

    def run_on_changes(paths)
      reload
    end

    alias :run_on_change :run_on_changes
  end
end

