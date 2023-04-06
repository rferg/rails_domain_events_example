# frozen_string_literal: true

module Event
  module Constants
    module Stages
      ALL = [
        BEFORE_COMMIT = :before_commit,
        AFTER_COMMIT = :after_commit
      ].freeze

      def self.valid?(stage)
        ALL.include?(stage)
      end

      def self.valid_or_raise(stage)
        raise ArgumentError, "stage #{stage} is not one of #{Stages::ALL}" unless valid?(stage)
      end
    end
  end
end
