# frozen_string_literal: true

FactoryBot.define do
  factory :coach do
    to_create(&:save)

    fullname { FFaker::Name.name }
    avatar { fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png') }
  end
end
