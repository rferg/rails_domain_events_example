# frozen_string_literal: true

module Moderation
  module Events
    class CreateCaseOnUserBanned < Event::ApplicationEventHandler
      handles ::Events::UserBanned, on: :before_commit

      def handle(event)
        Case.create_user_banned!(event.user_id)
      end
    end
  end
end
