require 'spec_helper'
require 'guard/rails/runner'
require 'fakefs/spec_helpers'

describe Guard::RailsRunner do
  let(:runner) { Guard::RailsRunner.new(options) }
  let(:environment) { 'development' }
  let(:port) { 3000 }
  
  let(:default_options) { { :environment => environment, :port => port } }
  let(:options) { default_options }
  
  describe '#pid' do
    include FakeFS::SpecHelpers

    context 'pid file exists' do
      let(:pid) { 12345 }

      before do
        FileUtils.mkdir_p File.split(runner.pid_file).first
        File.open(runner.pid_file, 'w') { |fh| fh.print pid }
      end

      it "should read the pid" do
        runner.pid.should == pid
      end
    end

    context 'pid file does not exist' do
      it "should return nil" do
        runner.pid.should be_nil
      end
    end
  end

  describe '#build_rails_command' do
    context 'no daemon' do
      it "should not have a daemon switch" do
        runner.build_rails_command.should_not match(%r{ -d})
      end
    end

    context 'daemon' do
      let(:options) { default_options.merge(:daemon => true) }

      it "should have a daemon switch" do
        runner.build_rails_command.should match(%r{ -d})
      end
    end
    
    context 'debugger' do
      let(:options) { default_options.merge(:debugger => true) }

      it "should have a debugger switch" do
        runner.build_rails_command.should match(%r{ -u})
      end
    end

    context 'custom server' do
      let(:options) { default_options.merge(:server => 'thin') }

      it "should have the server name" do
        runner.build_rails_command.should match(%r{thin})
      end
    end
    
    context 'custom app path' do
      let(:options) { default_options.merge(:app_path => 'spec/dummy') }

      it "should have the app path" do
        runner.build_rails_command.should match(%r{spec/dummy})
      end
    end    
  end

  describe '#start' do
    let(:kill_expectation) { runner.expects(:kill_unmanaged_pid!) }
    let(:pid_stub) { runner.stubs(:has_pid?) }

    before do
      runner.expects(:run_rails_command!).once
    end

    context 'do not force run' do
      before do
        pid_stub.returns(true)
        kill_expectation.never
        runner.expects(:wait_for_pid_action).never
      end

      it "should act properly" do
        runner.start.should be_true
      end
    end

    context 'force run' do
      let(:options) { default_options.merge(:force_run => true) }

      before do
        pid_stub.returns(true)
        kill_expectation.once
        runner.expects(:wait_for_pid_action).never
      end

      it "should act properly" do
        runner.start.should be_true
      end
    end

    context "don't write the pid" do
      before do
        pid_stub.returns(false)
        kill_expectation.never
        runner.expects(:wait_for_pid_action).times(Guard::RailsRunner::MAX_WAIT_COUNT)
      end

      it "should act properly" do
        runner.start.should be_false
      end
    end
  end

  describe '#sleep_time' do
    let(:timeout) { 30 }
    let(:options) { default_options.merge(:timeout => timeout) }

    it "should adjust the sleep time as necessary" do
      runner.sleep_time.should == (timeout.to_f / Guard::RailsRunner::MAX_WAIT_COUNT.to_f)
    end
  end
end
