# frozen_string_literal: true

FactoryBot.define do
  factory :moderation_case, class: 'Moderation::Case' do
    user
    status { 0 }
    category { 'MyString' }
  end
end
