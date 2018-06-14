# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.unique.email }
    fullname { FFaker::Name.name }
    password { FFaker::Internet.password }
    password_confirmation { password }

    trait :admin do
      admin true
    end
  end
end
