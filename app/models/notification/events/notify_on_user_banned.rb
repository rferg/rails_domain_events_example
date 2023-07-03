# frozen_string_literal: true

module Notification
  module Events
    class NotifyOnUserBanned < Event::ApplicationEventHandler
      handles ::Events::UserBanned

      def handle(event)
        Content.create_for_user!(event.user_id, title: 'Banned', body: "You've been banned.")
      end
    end
  end
end

# This is a domain event handler.
# It runs some code in response to an event.
# There is a one-many relationship between events and handlers.
