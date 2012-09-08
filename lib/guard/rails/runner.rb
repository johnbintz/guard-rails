require 'fileutils'
require 'timeout'
require 'childprocess'
require 'sys/proctable'

module Guard
  class RailsRunner
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def start
      kill_unmanaged_pid! if options[:force_run]
      process = run_rails_command!
      rails_started = wait_for_rails
      File.open(pid_file, "w") {|file| file.write process.pid} if rails_started
      rails_started
    end

    def stop
      if has_pid?
        unless windows?
          Process.kill Signal.list["INT"], pid rescue nil
        else
          kill_all_child_processes
        end
        FileUtils.rm pid_file, :force => true
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
      rails_options << '-u' if options[:debugger]
      rails_options << options[:server] if options[:server]

      cmd = []
      if windows?
        cmd << 'cmd' << '/C'
      end
      cmd << "rails server #{rails_options.join(' ')}"
    end

    def pid_file
      File.expand_path("tmp/pids/#{options[:environment]}.pid")
    end

    def pid
      File.file?(pid_file) ? File.read(pid_file).to_i : nil
    end

    private

    def run_rails_command!
      process = ChildProcess.build *build_rails_command
      process.environment["RAILS_ENV"] = options[:environment]
      process.io.inherit!
      process.start
      process
    end

    def has_pid?
      File.file?(pid_file)
    end

    def kill_unmanaged_pid!
      if pid = unmanaged_pid
        Process.kill Signal.list["KILL"], pid
        FileUtils.rm pid_file if has_pid?
      end
    end

    def unmanaged_pid
      unless windows?
        %x{lsof -n -i TCP:#{options[:port]}}.each_line { |line|
          if line["*:#{options[:port]} "]
            return line.split("\s")[1]
          end
        }
      else
        %x{netstat -ano}.each_line { |line| 
          protocol, local_address, _, state, pid = line.strip.split(/\s+/)          
          return pid.to_i if protocol == "TCP" && 
                          state == "LISTENING" && 
                          local_address =~ /:#{options[:port]}$/
        }
      end
      nil
    end

    private

    def wait_for_rails
      Timeout.timeout(options[:timeout]) {sleep 1 until rails_running?}
      true
    rescue Timeout::Error
      false
    end

    def rails_running?
      return false unless has_pid?
      TCPSocket.new('127.0.0.1', options[:port]).close
      true
    rescue Errno::ECONNREFUSED
      false
    end

    def windows?
      RUBY_PLATFORM =~ /mswin|msys|mingw/ 
    end
    
    def kill_all_child_processes
      all_pids_for(pid).each do |pid|
        Process.kill Signal.list["KILL"], pid rescue nil
      end
    end

    def all_pids_for(parent_pid)
      pids = [parent_pid]
      Sys::ProcTable.ps do |process|
        pids += all_pids_for(process.pid) if process.ppid == parent_pid
      end
      pids
    end
  end
end

