# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    to_create(&:save)

    name { FFaker::Video.name }
    content { FFaker::Video.file }
  end
end
