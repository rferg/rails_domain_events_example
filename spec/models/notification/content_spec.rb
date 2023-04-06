# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification::Content do
  describe 'validations' do
    subject { build(:notification_content) }

    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:title) }
  end
end
