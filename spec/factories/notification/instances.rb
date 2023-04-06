# frozen_string_literal: true

FactoryBot.define do
  factory :notification_instance, class: 'Notification::Instance' do
    user
    notification_content
    status { 0 }

    trait :read do
      status { 1 }
    end
  end
end
