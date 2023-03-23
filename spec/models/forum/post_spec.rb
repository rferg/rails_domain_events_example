# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forum::Post do
  describe 'validations' do
    subject { build(:forum_post) }

    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:title) }
  end
end
