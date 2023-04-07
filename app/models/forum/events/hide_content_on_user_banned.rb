# frozen_string_literal: true

module Forum
  module Events
    class HideContentOnUserBanned < Event::ApplicationEventHandler
      handles ::Events::UserBanned, on: :before_commit

      def handle(event)
        event.user.posts.update!(status: :inactive)
        event.user.comments.update!(status: :inactive)
      end
    end
  end
end
