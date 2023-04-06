# frozen_string_literal: true

require 'rails_helper'

module Event
  TestHandler = Class.new(ApplicationEventHandler)
  OtherTestHandler = Class.new(ApplicationEventHandler)
  AdditionalTestHandler = Class.new(ApplicationEventHandler)
  TestEvent = Class.new(ApplicationEvent)
  OtherTestEvent = Class.new(ApplicationEvent)
  SubEvent = Class.new(TestEvent)

  RSpec.describe HandlerRegistry do
    let(:registry) { described_class.instance }
    let(:after_commit) { Constants::Stages::AFTER_COMMIT }
    let(:before_commit) { Constants::Stages::BEFORE_COMMIT }

    before { registry.reset }

    def handlers_for(event)
      registry.registrations_for(event).map(&:handler_class)
    end

    describe '#register' do
      it 'raises ArgumentError if handler_class is blank' do
        expect { registry.register(nil, ApplicationEvent, after_commit) }.to raise_error(ArgumentError, /handler_class/)
      end

      it 'raises ArgumentError if handler_class is not a Class' do
        [0, [], {}, ApplicationEventHandler.new].each do |invalid_item|
          expect { registry.register(invalid_item, ApplicationEvent, after_commit) }
            .to raise_error(ArgumentError, /handler_class/)
        end
      end

      it 'raises ArgumentError if event_class is not a Class' do
        [0, [], {}, ApplicationEvent.new].each do |invalid_item|
          expect { registry.register(ApplicationEventHandler, invalid_item, after_commit) }
            .to raise_error(ArgumentError, /event_class/)
        end
      end

      it 'raises ArgumentError if event_class does not inherit from ApplicationEvent' do
        [Array, Object, StandardError].each do |invalid_class|
          expect { registry.register(ApplicationEventHandler, invalid_class, after_commit) }
            .to raise_error(ArgumentError, /#{ApplicationEvent}/)
        end
      end

      it 'registers handler with stage value' do
        expected = [HandlerRegistry::Registration.new(TestHandler, after_commit)]
        registry.register(TestHandler, TestEvent, after_commit)
        registrations = registry.registrations_for(TestEvent.new)
        expect(registrations).to match_array(expected)
      end

      it 'registers two handlers of the same class if they have different stage values' do
        expected = [after_commit, before_commit].map do |stage|
          registry.register(TestHandler, TestEvent, stage)
          HandlerRegistry::Registration.new(TestHandler, stage)
        end
        expect(registry.registrations_for(TestEvent.new)).to match_array(expected)
      end

      it 'registers handler when event class has previous handler' do
        expected = [TestHandler, OtherTestHandler]
        expected.each { |handler| registry.register(handler, TestEvent, after_commit) }
        expect(handlers_for(TestEvent.new)).to match_array(expected)
      end

      it 'does not register duplicate handlers for the same event' do
        3.times.each { registry.register(TestHandler, TestEvent, after_commit) }
        expect(handlers_for(TestEvent.new)).to contain_exactly(TestHandler)
      end

      it 'registers the same handler for different events' do
        registry.register(TestHandler, TestEvent, after_commit)
        registry.register(TestHandler, OtherTestEvent, after_commit)
        expect(handlers_for(TestEvent.new)).to contain_exactly(TestHandler)
        expect(handlers_for(OtherTestEvent.new)).to contain_exactly(TestHandler)
      end

      it 'registers handlers for the same event from multiple threads' do
        expected = [TestHandler, OtherTestHandler, AdditionalTestHandler]
        expected.map { |handler| Thread.new { registry.register(handler, TestEvent, after_commit) } }
                .each(&:join)
        expect(handlers_for(TestEvent.new)).to match_array(expected)
      end
    end

    describe '#registrations_for' do
      it 'raises ArgumentError if event is nil' do
        expect { registry.registrations_for(nil) }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError if event is not an ApplicationEvent' do
        expect { registry.registrations_for([]) }.to raise_error(ArgumentError)
      end

      it 'is empty if no handlers have been registered' do
        expect(registry.registrations_for(TestEvent.new)).to be_empty
      end

      it 'returns the handlers registered for an event' do
        expected = [TestHandler, OtherTestHandler]
        expected.each { |handler| registry.register(handler, TestEvent, after_commit) }
        expect(handlers_for(TestEvent.new)).to match_array(expected)
      end

      it 'returns the handlers registered for an event and its superclasses' do
        expected = [TestHandler, OtherTestHandler, AdditionalTestHandler]
        registry.register(expected[0], TestEvent, after_commit)
        registry.register(expected[1], SubEvent, after_commit)
        registry.register(expected[2], ApplicationEvent, after_commit)
        expect(handlers_for(SubEvent.new)).to match_array(expected)
      end

      it 'does not return duplicate handlers registered for different events' do
        registry.register(TestHandler, TestEvent, after_commit)
        registry.register(TestHandler, SubEvent, after_commit)
        expect(handlers_for(SubEvent.new)).to contain_exactly(TestHandler)
      end
    end
  end
end
