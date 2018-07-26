# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :video_categories do
      primary_key :id

      String :name, null: false, unique: true

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
