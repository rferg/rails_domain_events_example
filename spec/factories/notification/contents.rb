# frozen_string_literal: true

FactoryBot.define do
  factory :notification_content, class: 'Notification::Content' do
    title { 'MyText' }
    body { 'MyText' }
  end
end
