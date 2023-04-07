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

  def ban_with_no_event!
    User.transaction do
      banned!
      posts.update!(status: :inactive)
      comments.update!(status: :inactive)
    end
  end

  # Putting side effects here makes this model dependent on other models
  # across multiple module boundaries. Now the dependencies go both ways (user -> x, x -> user)
  # and become more and more difficult to track as the codebase grows.  This
  # breaks down modularity and leads to a ball of mud.
  def ball_of_mud_ban!
    return true if banned?

    User.transaction do
      banned!
      posts.update!(status: :inactive)
      comments.update!(status: :inactive)
    end
    Notification::Content.create_for_user!(self, title: 'Banned', body: "You've been banned")
    Moderation::Case.create_user_banned!(self)
  end
end
