# frozen_string_literal: true

require 'rails_helper'

module Event
  RSpec.describe ApplicationEventHandler do
    let!(:registry) do
      mock = instance_double(HandlerRegistry)
      allow(mock).to receive(:register)
      allow(HandlerRegistry).to receive(:instance).and_return(mock)
      mock
    end

    describe '.handles' do
      it 'registers handler with given event class and stage' do
        described_class.handles(ApplicationEvent, on: Constants::Stages::BEFORE_COMMIT)

        expect(registry).to have_received(:register)
          .with(described_class, ApplicationEvent, Constants::Stages::BEFORE_COMMIT)
      end

      it 'raises ArgumentError if on value is not a valid stage' do
        expect { described_class.handles(ApplicationEvent, on: :invalid) }.to raise_error(ArgumentError, /invalid/)
      end
    end

    describe '#handle' do
      it 'raises NoMethodError' do
        expect { described_class.new.handle(ApplicationEvent.new) }.to raise_error(NoMethodError)
      end
    end

    describe '.handle' do
      it 'instantiates and calls handle passing the event' do
        mock = instance_double(described_class, handle: nil)
        allow(described_class).to receive(:new).and_return(mock)
        event = ApplicationEvent.new
        described_class.handle(event)
        expect(mock).to have_received(:handle).with(event)
      end
    end
  end
end
