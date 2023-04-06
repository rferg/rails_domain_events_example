# frozen_string_literal: true

require 'concurrent'
require 'singleton'

module Event
  class HandlerRegistry
    include Singleton

    Registration = Struct.new(:handler_class, :stage)

    def initialize
      reset
    end

    def register(handler_class, event_class, stage)
      assert_valid_registration(handler_class, event_class)
      registrations.put_if_absent(event_class, Concurrent::Set.new)
      registrations.compute(event_class) { |regs| regs << Registration.new(handler_class, stage) }
    end

    def registrations_for(event)
      event_class = event.class
      assert_valid_event_class(event_class)
      collect_registrations(event_class)
    end

    def reset
      @registrations = Concurrent::Map.new
    end

    private

    attr_reader :registrations

    def event_base_class
      ApplicationEvent
    end

    def collect_registrations(key_class, collected = Concurrent::Set.new)
      return collected if key_class > event_base_class

      current_registrations = registrations.fetch(key_class, Concurrent::Set.new)
      collect_registrations(key_class.superclass, collected | current_registrations)
    end

    def assert_valid_registration(handler_class, event_class)
      raise ArgumentError, 'handler_class must be a Class' unless handler_class.is_a?(Class)

      assert_valid_event_class(event_class)
    end

    def assert_valid_event_class(event_class)
      raise ArgumentError, 'event_class must be a Class' unless event_class.is_a?(Class)
      raise ArgumentError, "#{event_class} is not a #{event_base_class}" unless event_class <= event_base_class
    end
  end
end
