# frozen_string_literal: true

class User < ApplicationRecord
  enum :status, %i[inactive active banned]

  validates :email, presence: true, uniqueness: true
end
