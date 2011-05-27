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
      system %{sh -c '[[ -f tmp/pids/#{options[:environment]}.pid ]] && kill $(cat tmp/pids/#{options[:environment]}.pid)'}
      system %{rails s -d -e #{options[:environment]} -p #{options[:port]}}
    end

    def run_on_change(paths)
      run_all
    end
  end
end

