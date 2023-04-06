# frozen_string_literal: true

module Event
  PublisherTestEvent = Class.new(ApplicationEvent)
  HandlerA = Class.new(ApplicationEventHandler)
  HandlerB = Class.new(ApplicationEventHandler)
  HandlerC = Class.new(ApplicationEventHandler)

  RSpec.describe Publisher do
    let(:registry) { instance_double(HandlerRegistry) }
    let(:publisher) { described_class.new(registry) }

    before do
      allow(registry).to receive(:registrations_for).and_return([])
    end

    describe '#publish' do
      let(:stage) { Constants::Stages::AFTER_COMMIT }
      let(:event) { PublisherTestEvent.new }

      def publish
        publisher.publish(event, stage)
      end

      def registration(klass, stage)
        HandlerRegistry::Registration.new(klass, stage)
      end

      it 'raises ArgumentError if given invalid stage' do
        expect { publisher.publish(event, :invalid) }.to raise_error(ArgumentError, /invalid/)
      end

      it 'does not attempt to publish event if already published for given stage' do
        event.record_publication(stage)
        publish
        expect(registry).not_to have_received(:registrations_for)
      end

      it 'records the publication on the event for the given stage' do
        publish
        expect(event.published?(stage)).to be(true)
      end

      context 'when event has handlers' do
        let(:registrations) do
          regs = [registration(HandlerA, stage), registration(HandlerB, :other), registration(HandlerC, stage)]
          regs.each { |reg| allow(reg.handler_class).to receive(:handle) }
          regs
        end

        before do
          allow(registry).to receive(:registrations_for).with(event).and_return(registrations)
        end

        it 'calls handle on all and only the handlers for the given stage' do
          publish
          expect(HandlerA).to have_received(:handle).with(event)
          expect(HandlerB).not_to have_received(:handle).with(event)
          expect(HandlerC).to have_received(:handle).with(event)
        end
      end
    end
  end
end
