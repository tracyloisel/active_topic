# frozen_string_literal: true

require 'active_topic/base'

RSpec.describe ActiveTopic::Base do
  describe '.initialize' do
    context 'when class is ActiveTopic::Base' do
      it 'raises an error' do
        expect { ActiveTopic::Base.new }.to raise_error(ActiveTopic::Exceptions::CantBeIniatilized)
      end
    end

    context 'when class is deriving from ActiveTopic::Base' do
      before(:all) { class DummyClass < ActiveTopic::Base; end }

      it 'instantiates a new instance' do
        expect(DummyClass.new).to be_a(DummyClass)
      end
    end
  end

  describe '#create_topic!' do
    before(:all) { class DummyClass < ActiveTopic::Base; end }

    it 'creates a topic' do
      allow_any_instance_of(ActiveTopic::Base).to(receive(:pubsub))
                                              .and_return(Google::Cloud::PubSub::Project.new('dummy'))
      expect_any_instance_of(Google::Cloud::PubSub::Project).to receive(:create_topic)

      DummyClass.new.create_topic!
    end
  end
end
