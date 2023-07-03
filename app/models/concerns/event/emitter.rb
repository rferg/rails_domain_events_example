# frozen_string_literal: true

module Event
  module Emitter
    include ::Event::Constants
    extend ActiveSupport::Concern

    included do
      after_save :publish_events_before_commit
      after_destroy :publish_events_before_commit
      after_commit :publish_events_after_commit
    end

    def add_event(event)
      events << event
    end

    private

    def events
      @events ||= []
    end

    def publish_events_before_commit
      publish_events(Stages::BEFORE_COMMIT)
    end

    def publish_events_after_commit
      publish_events(Stages::AFTER_COMMIT)
    end

    def publish_events(stage)
      # Event handlers may add new events to the model,
      # so we need to retrieve the events one at a time after each publish.
      loop do
        event = events.find { |e| e&.unpublished?(stage) }
        break if event.blank?

        ::Event::Publisher.publish(event, stage)
      end
    end
  end
end
