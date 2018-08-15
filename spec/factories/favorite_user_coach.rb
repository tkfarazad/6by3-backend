# frozen_string_literal: true

FactoryBot.define do
  factory :favorite_user_coach do
    to_create(&:save)

    user
    coach
  end
end
