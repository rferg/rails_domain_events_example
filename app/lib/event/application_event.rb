# frozen_string_literal: true

module Event
  class ApplicationEvent
    attr_reader :occurred_at

    def initialize(*_args)
      @occurred_at = Time.current
    end

    def record_publication(stage, now: Time.current)
      raise "Already published #{self.class.name} at stage #{stage}" if publications.key?(stage)

      publications[stage] = now
    end

    def published?(stage)
      publications.key?(stage)
    end

    def unpublished?(stage)
      !published?(stage)
    end

    private

    def publications
      @publications ||= {}
    end
  end
end
