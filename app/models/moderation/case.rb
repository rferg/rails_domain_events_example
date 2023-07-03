# frozen_string_literal: true

module Moderation
  module Constants
    module Categories
      ALL = [
        BAN = 'User Banned'
      ].freeze
    end
  end

  class Case < ApplicationRecord
    include Moderation::Constants

    enum :status, %i[open closed]

    belongs_to :user

    validates :category, inclusion: { in: Categories::ALL }

    def self.create_user_banned!(user_id)
      create!(user_id:, category: Categories::BAN)
    end
  end
end
