# frozen_string_literal: true

FactoryBot.define do
  factory :coaches_video do
    to_create(&:save)

    coach
    video
  end
end
