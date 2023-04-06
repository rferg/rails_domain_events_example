# frozen_string_literal: true

module Event
  class ApplicationEventHandler
    include Constants

    def self.handle(event)
      new.handle(event)
    end

    def self.handles(event_class, on: Stages::AFTER_COMMIT)
      Stages.valid_or_raise(on)

      HandlerRegistry.instance.register(self, event_class, on)
    end

    def handle(_event)
      raise NoMethodError, 'must implement handle'
    end
  end
end
