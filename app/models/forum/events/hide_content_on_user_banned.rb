# frozen_string_literal: true

module Forum
  module Events
    class HideContentOnUserBanned < Event::ApplicationEventHandler
      # on: :before_commit means that this code will run in the same
      # transaction as the original operation(s) that triggered the event.
      handles ::Events::UserBanned, on: :before_commit

      def handle(event)
        event.user.posts.update!(status: :inactive)
        event.user.comments.update!(status: :inactive)
      end
    end
  end
end
