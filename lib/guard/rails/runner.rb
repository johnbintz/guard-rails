require 'fileutils'

module Guard
  class RailsRunner
    MAX_WAIT_COUNT = 10

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def start
      kill_unmanaged_pid! if options[:force_run]
      run_rails_command!
      count = 0
      while !has_pid? && count < MAX_WAIT_COUNT
        wait_for_pid_action
        count += 1
      end
      !(count == MAX_WAIT_COUNT)
    end

    def stop
      if File.file?(pid_file)
        system %{kill -KILL #{File.read(pid_file).strip}}
        sleep sleep_time
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

    def pid_file
      File.expand_path("tmp/pids/#{options[:environment]}.pid")
    end

    def pid
      File.file?(pid_file) ? File.read(pid_file).to_i : nil
    end

    def sleep_time
      options[:timeout].to_f / MAX_WAIT_COUNT.to_f
    end

    private
    def run_rails_command!
      system build_rails_command
    end

    def has_pid?
      File.file?(pid_file)
    end

    def wait_for_pid_action
      sleep sleep_time
    end

    def kill_unmanaged_pid!
      if pid = unmanaged_pid
        system %{kill -KILL #{pid}} 
        FileUtils.rm pid_file
      end
    end

    def unmanaged_pid
      pid_command = "lsof -n -i TCP:#{options[:port]}"
      %x{#{pid_command}}.each_line { |line|
        if line["*:#{options[:port]} "]
          return line.split("\s")[1]
        end
      }
      nil
    end
  end
end

