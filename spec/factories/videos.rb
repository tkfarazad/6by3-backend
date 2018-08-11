# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    to_create(&:save)

    name { FFaker::Video.name }
    url 'http://127.0.0.1:3000/video.mp4'
    content_type { ::SixByThree::Constants::AVAILABLE_UPLOAD_VIDEO_CONTENT_TYPES.sample }
    duration 170
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
