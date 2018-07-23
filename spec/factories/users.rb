# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    to_create(&:save)

    email { FFaker::Internet.unique.email }
    fullname { FFaker::Name.name }
    avatar { fixture_file_upload('spec/fixtures/files/image.png', 'image/png') }
    password { FFaker::Internet.password }
    password_confirmation { password }

    trait :admin do
      admin true
    end

    trait :deleted do
      deleted_at Time.current
    end

    trait :confirmed do
      email_confirmed_at { Time.current - 1.day }
      email_confirmation_token nil
      email_confirmation_requested_at { Time.current - 3.days }
    end

    trait :unconfirmed do
      email_confirmed_at nil
      email_confirmation_token { SecureRandom.uuid }
      email_confirmation_requested_at { Time.current - 1.day }
    end

    trait :reset_password_requested do
      reset_password_token { SecureRandom.uuid }
      reset_password_requested_at { Time.current }
    end
  end
end
