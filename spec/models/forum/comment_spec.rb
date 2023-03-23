# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forum::Comment do
  describe 'validations' do
    subject { build(:forum_comment) }

    it { is_expected.to validate_presence_of(:body) }
  end
end
