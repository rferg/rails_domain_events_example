# frozen_string_literal: true

class User < ApplicationRecord
  include Event::Emitter

  enum :status, %i[inactive active banned]

  has_many :posts, dependent: :destroy, class_name: 'Forum::Post'
  has_many :comments, dependent: :destroy, class_name: 'Forum::Comment'
  has_many :notifications, dependent: :destroy, class_name: 'Notification::Instance'
  has_many :cases, dependent: :destroy, class_name: 'Moderation::Case'

  validates :email, presence: true, uniqueness: true

  def ban!
    return true if banned?

    add_event(Events::UserBanned.new(self))
    banned!
  end
end
