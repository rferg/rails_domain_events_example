# frozen_string_literal: true

module Event
  class Publisher
    include Constants

    def self.publish(event, stage)
      new.publish(event, stage)
    end

    def initialize(registry = HandlerRegistry.instance)
      @registry = registry
    end

    def publish(event, stage)
      Stages.valid_or_raise(stage)
      return if event.published?(stage)

      registry.registrations_for(event)
              .select { |reg| reg.stage == stage }
              .each { |reg| reg.handler_class.handle(event) }
      event.record_publication(stage)
    end

    private

    attr_reader :registry
  end
end
