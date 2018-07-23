# frozen_string_literal: true

FactoryBot.define do
  factory :coach do
    to_create(&:save)

    fullname { FFaker::Name.name }
    avatar { fixture_file_upload('spec/fixtures/files/image.png', 'image/png') }
    certifications { Array.new(3).fill { FFaker::Job.title } }
    personal_info { FFaker::Book.description }
  end
end
