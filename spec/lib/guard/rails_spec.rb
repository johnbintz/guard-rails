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
end

