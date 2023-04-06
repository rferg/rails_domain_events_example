# frozen_string_literal: true

module Notification
  class Instance < ApplicationRecord
    enum :status, %i[unread read]

    belongs_to :user
    belongs_to :notification_content, class_name: 'Notification::Content'

    def mark_read!
      return if read?

      read!
    end

    def mark_unread!
      return if unread?

      unread!
    end
  end
end
