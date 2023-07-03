# frozen_string_literal: true

class User < ApplicationRecord
  include Event::Emitter

  enum :status, %i[inactive active banned]

  has_many :posts, dependent: :destroy, class_name: 'Forum::Post'
  has_many :comments, dependent: :destroy, class_name: 'Forum::Comment'

  validates :email, presence: true, uniqueness: true

  def ban!
    return true if banned?

    add_event(Events::UserBanned.new(id))
    banned!
  end

  def ban_with_no_event!
    banned!
  end

  # Putting side effects here makes this model dependent on other models
  # across multiple module boundaries. Now the dependencies go both ways (user -> x, x -> user)
  # and become more and more difficult to track as the codebase grows.  This
  # breaks down modularity and leads to a ball of mud.
  def ball_of_mud_ban!
    return true if banned?

    transaction do
      banned!
      Moderation::Case.create_user_banned!(id)
    end
    Notification::Content.create_for_user!(id, title: 'Banned', body: "You've been banned")
  end
end
