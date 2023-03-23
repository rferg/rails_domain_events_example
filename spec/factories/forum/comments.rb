# frozen_string_literal: true

FactoryBot.define do
  factory :forum_comment, class: 'Forum::Comment' do
    user
    forum_post
    body { 'MyText' }
    status { 1 }
  end
end
