# frozen_string_literal: true

FactoryBot.define do
  factory :auth_token do
    to_create(&:save)

    token { SecureRandom.uuid }
    user
  end
end
