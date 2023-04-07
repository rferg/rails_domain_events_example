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

# This is a domain event: an explicit representation of something that happened.
# [go back to user.rb to see how these are used in models]
