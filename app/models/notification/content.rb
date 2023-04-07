# frozen_string_literal: true

module Notification
  class Content < ApplicationRecord
    validates :title, :body, presence: true

    def self.create_for_user!(user, **attributes)
      Notification::Content.transaction do
        content = create!(**attributes)
        Instance.create!(user:, notification_content: content)
      end
    end
  end
end
