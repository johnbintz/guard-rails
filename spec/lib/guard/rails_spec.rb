require 'spec_helper'
require 'guard/rails'

describe Guard::Rails do
  let(:guard) { Guard::Rails.new(watchers, options) }
  let(:watchers) { [] }
  let(:options) { {} }

  describe '#initialize' do
    it "should initialize with options" do
      guard
    end
  end

  describe '#run_all' do
    let(:pid) { '12345' }

    before do
      Guard::UI.expects(:info).with('Restarting Rails...')
      Guard::Notifier.expects(:notify).with(regexp_matches(/Rails restarting/), anything)
      Guard::RailsRunner.any_instance.stubs(:pid).returns(pid)
    end

    let(:runner_stub) { Guard::RailsRunner.any_instance.stubs(:restart) }

    context 'with pid file' do
      before do
        runner_stub.returns(true)
      end

      it "should restart and show the pid file" do
        Guard::UI.expects(:info).with(regexp_matches(/#{pid}/))
        Guard::Notifier.expects(:notify).with(regexp_matches(/Rails restarted/), anything)

        guard.run_all
      end
    end

    context 'no pid file' do
      before do
        runner_stub.returns(false)
      end

      it "should restart and show the pid file" do
        Guard::UI.expects(:info).with(regexp_matches(/#{pid}/)).never
        Guard::UI.expects(:info).with(regexp_matches(/Rails NOT restarted/))
        Guard::Notifier.expects(:notify).with(regexp_matches(/Rails NOT restarted/), anything)

        guard.run_all
      end
    end
  end
end

