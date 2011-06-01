module Guard
  class RailsRunner
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def start
      kill_unmanaged_pid! if options[:force_run]
      run_rails_command!
      count = 0
      while !has_pid? && count < 10
        wait_for_pid_action
        count += 1
      end
    end

    def stop
      if File.file?(pid_file)
        system %{kill -INT #{File.read(pid_file).strip}}
      end
    end
    
    def restart
      stop
      start
    end

    def build_rails_command
      rails_options = [
        '-e', options[:environment],
        '-p', options[:port],
        '--pid', pid_file
      ]

      rails_options << '-d' if options[:daemon]

      %{sh -c 'cd #{Dir.pwd} && rails s #{rails_options.join(' ')} &'}
    end

    private
    def run_rails_command!
      system build_rails_command
    end

    def has_pid?
      File.file?(pid_file)
    end

    def wait_for_pid_action
      0.5
    end

    def pid_file
      File.expand_path("tmp/pids/#{options[:environment]}.pid")
    end

    def kill_unmanaged_pid!
      if pid = unmanaged_pid
        system %{kill -INT #{pid}}
      end
    end

    def unmanaged_pid
      if RbConfig::CONFIG['host_os'] =~ /darwin/
        %x{lsof -P}.each_line { |line|
          if line["*:#{options[:port]} "]
            return line.split("\s")[1]
          end
        }
      end
      nil
    end
  end
end

