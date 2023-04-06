# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification::Instance do
  describe '#mark_read!' do
    it 'saves as read if unread' do
      instance = build(:notification_instance)

      instance.mark_read!

      expect(instance.read?).to be(true)
    end

    it 'remains read if already read' do
      instance = build(:notification_instance, :read)

      instance.mark_read!

      expect(instance.read?).to be(true)
    end
  end

  describe '#mark_unread' do
    it 'saves as unread if read' do
      instance = build(:notification_instance, :read)

      instance.mark_unread!

      expect(instance.unread?).to be(true)
    end

    it 'remains unread if already unread' do
      instance = build(:notification_instance)

      instance.mark_unread!

      expect(instance.unread?).to be(true)
    end
  end
end
