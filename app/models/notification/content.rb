# frozen_string_literal: true

module Notification
  class Content < ApplicationRecord
    validates :title, :body, presence: true
  end
end
