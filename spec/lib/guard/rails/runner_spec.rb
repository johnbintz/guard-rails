require 'spec_helper'
require 'guard/rails/runner'

describe Guard::RailsRunner do
  let(:runner) { Guard::RailsRunner.new(options) }
  let(:environment) { 'development' }
  let(:port) { 3000 }
  
  let(:default_options) { { :environment => environment, :port => port } }
  let(:options) { default_options }
  

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
        runner.start
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
        runner.start
      end
    end

    context "don't write the pid" do
      before do
        pid_stub.returns(false)
        kill_expectation.never
        runner.expects(:wait_for_pid_action).times(10)
      end

      it "should act properly" do
        runner.start
      end
    end
  end
end
