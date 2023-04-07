# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moderation::Case do
  describe 'validations' do
    subject { build(:moderation_case) }

    it { is_expected.to validate_inclusion_of(:category).in_array(Moderation::Constants::Categories::ALL) }
  end
end
