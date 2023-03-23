# frozen_string_literal: true

module Forum
  class Comment < ApplicationRecord
    enum :status, %i[inactive active archived]

    belongs_to :user
    belongs_to :forum_post, class_name: 'Forum::Post'

    validates :body, presence: true
  end
end
