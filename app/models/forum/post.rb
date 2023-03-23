# frozen_string_literal: true

module Forum
  class Post < ApplicationRecord
    enum :status, %i[inactive active archived]

    belongs_to :user

    validates :title, :body, presence: true
  end
end
