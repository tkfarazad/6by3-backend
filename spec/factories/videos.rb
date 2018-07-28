# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    to_create(&:save)

    name { FFaker::Video.name }
    content { FFaker::Video.file }
    duration { 170.859 }
    lesson_date { Time.current }
    description { FFaker::Book.description }

    trait :deleted do
      deleted_at Time.current
    end

    trait :with_category do
      after(:create) do |video|
        video.update(category: create(:video_category))
      end
    end
  end
end
