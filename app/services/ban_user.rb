# frozen_string_literal: true

class BanUser < ApplicationService
  attr_reader :user

  def initialize(user)
    @user = user
    super
  end

  def call
    return true if user.banned?

    user.ban_with_no_event!

    Notification::Content.create_for_user!(user, title: 'Banned', body: "You've been banned")
    Moderation::Case.create_user_banned!(user)
  end
end

# With a Service Object we've improved things by removing
# direct coupling between User and the models in different modules.

# However, there's some drawbacks:

# - Violates Open/Closed Principle w.r.t. side effects
# - Violates Single Responsibility Principle
# - Side effect trigger is peripheral to domain model
#   - callers need to know to call BanUser.call and not just User#ban!
#   - removing User#ban! and moving logic into BanUser leads to Anemic Domain Model
# - Aren't we still violating module boundaries?
