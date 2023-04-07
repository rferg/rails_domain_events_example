# frozen_string_literal: true

module Events
  class UserBanned < Event::ApplicationEvent
    attr_reader :user

    def initialize(user)
      @user = user
      super
    end
  end
end
