# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    to_create(&:save)

    name { FFaker::Video.name }
    content { FFaker::Video.file }
    duration { "00:32:52" }
    description { FFaker::Book.description }
  end
end
