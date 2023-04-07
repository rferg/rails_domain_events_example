# frozen_string_literal: true

module Moderation
  module Events
    class CreateCaseOnUserBanned < Event::ApplicationEventHandler
      handles ::Events::UserBanned

      def handle(event)
        Case.create_user_banned!(event.user)
      end
    end
  end
end
