# frozen_string_literal: true

FactoryBot.define do
  factory :video_category do
    to_create(&:save)

    name ['Fusion Flow', 'Core 45', 'Follow The Yogi', 'Yin Fusion Flow'].sample
  end
end
