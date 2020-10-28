# frozen_string_literal: true

require 'active_topic/base'

RSpec.describe ActiveTopic::Base do
  before(:each) do
    stub_const('DummyClassTopic', Class.new(ActiveTopic::Base))
  end
  subject { DummyClassTopic.new }

  describe '.initialize' do
    context 'when class is ActiveTopic::Base' do
      it 'raises an ActiveTopic::Exceptions::CantBeIniatilized exception' do
        expect { ActiveTopic::Base.new }.to raise_exception(ActiveTopic::Exceptions::CantBeIniatilized)
      end
    end

    context 'when class inherits from ActiveTopic::Base' do
      it 'instantiates a new instance' do
        expect(DummyClassTopic.new).to be_a(DummyClassTopic)
      end
    end
  end

  describe 'delegated methods to #topic' do
    before(:each) do
      allow_any_instance_of(ActiveTopic::Base).to receive(:pubsub)
        .and_return(Google::Cloud::PubSub::Project.new('dummy'))
    end

    describe '#publish' do
      context 'when the topic exists' do
        before(:each) do
          allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic)
            .and_return(Google::Cloud::PubSub::Topic.new)
        end

        it 'calls publish on a Google::Cloud::PubSub::Topic object with arguments' do
          expect_any_instance_of(Google::Cloud::PubSub::Topic).to receive(:publish).with 'test'

          subject.publish 'test'
        end
      end

      context 'when the topic does not exist' do
        before(:each) { allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic).and_return(nil) }

        it 'raises an ActiveTopic::Exceptions::TopicNotFound exception' do
          expect { subject.publish 'test' }.to raise_exception(ActiveTopic::Exceptions::TopicNotFound)
        end
      end
    end

    describe '#publish_async' do
      context 'when the topic exists' do
        before(:each) do
          allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic)
            .and_return(Google::Cloud::PubSub::Topic.new)
        end

        it 'calls publish_async on a Google::Cloud::PubSub::Topic object with arguments' do
          expect_any_instance_of(Google::Cloud::PubSub::Topic).to receive(:publish_async).with 'test'

          subject.publish_async 'test'
        end
      end

      context 'when the topic does not exist' do
        before(:each) { allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic).and_return(nil) }

        it 'raises an ActiveTopic::Exceptions::TopicNotFound exception' do
          expect { subject.publish_async 'test' }.to raise_exception(ActiveTopic::Exceptions::TopicNotFound)
        end
      end
    end

    describe '#async_publisher' do
      context 'when the topic exists' do
        before(:each) do
          allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic)
            .and_return(Google::Cloud::PubSub::Topic.new)
        end

        it 'calls async_publisher on a Google::Cloud::PubSub::Topic object' do
          expect_any_instance_of(Google::Cloud::PubSub::Topic).to receive(:async_publisher)

          subject.async_publisher
        end
      end

      context 'when the topic does not exist' do
        before(:each) { allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic).and_return(nil) }

        it 'raises an ActiveTopic::Exceptions::TopicNotFound exception' do
          expect { subject.async_publisher }.to raise_exception(ActiveTopic::Exceptions::TopicNotFound)
        end
      end
    end

    describe '#subscribe' do
      context 'when the topic exists' do
        before(:each) do
          allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic)
            .and_return(Google::Cloud::PubSub::Topic.new)
        end

        it 'calls subscribe on a Google::Cloud::PubSub::Topic object with arguments' do
          expect_any_instance_of(Google::Cloud::PubSub::Topic).to receive(:subscribe).with 'test'

          subject.subscribe 'test'
        end
      end

      context 'when the topic does not exist' do
        before(:each) { allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic).and_return(nil) }

        it 'raises an ActiveTopic::Exceptions::TopicNotFound exception' do
          expect { subject.subscribe 'test' }.to raise_exception(ActiveTopic::Exceptions::TopicNotFound)
        end
      end
    end
  end

  describe '#create_topic!' do
    before(:each) do
      allow_any_instance_of(ActiveTopic::Base).to receive(:pubsub)
        .and_return(Google::Cloud::PubSub::Project.new('dummy'))
    end

    it 'calls create_topic on a Google::Cloud::PubSub::Project object with arguments' do
      expect_any_instance_of(Google::Cloud::PubSub::Project).to receive(:create_topic)
        .with(subject.class.to_s.sub(/Topic\z/, '').underscore)

      subject.create_topic!
    end
  end

  describe '#topic_created?' do
    before(:each) do
      allow_any_instance_of(ActiveTopic::Base).to receive(:pubsub)
        .and_return(Google::Cloud::PubSub::Project.new('dummy'))
    end

    context 'when the topic exists' do
      before(:each) do
        allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic)
          .with('dummy_class').and_return true
      end

      it 'calls #topic on a Google::Cloud::PubSub::Project and returns true' do
        expect_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic).with('dummy_class')
                                                                                 .and_return true

        subject.topic_created?
      end
    end

    context 'when the topic does not exist' do
      before(:each) do
        allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic)
          .with('dummy_class').and_return false
      end

      it 'calls #topic on a Google::Cloud::PubSub::Project and returns true' do
        expect_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic).with('dummy_class')
                                                                                 .and_return true

        subject.topic_created?
      end
    end
  end
end
