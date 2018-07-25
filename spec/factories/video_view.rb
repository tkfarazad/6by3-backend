# frozen_string_literal: true

FactoryBot.define do
  factory :video_view do
    to_create(&:save)

    user
    video
  end
end
