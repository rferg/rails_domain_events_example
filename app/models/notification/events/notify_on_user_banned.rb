# frozen_string_literal: true

module Notification
  module Events
    class NotifyOnUserBanned < Event::ApplicationEventHandler
      handles ::Events::UserBanned

      def handle(event)
        Content.create_for_user!(event.user, title: 'Banned', body: "You've been banned.")
      end
    end
  end
end
