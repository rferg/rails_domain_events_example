# frozen_string_literal: true

FactoryBot.define do
  factory :forum_post, class: 'Forum::Post' do
    user
    title { 'MyText' }
    body { 'MyText' }
    status { 1 }
  end
end
