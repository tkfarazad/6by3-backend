# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :coaches_videos do
      primary_key :id

      foreign_key :coach_id, :coaches, null: false, index: true, unique: true
      foreign_key :video_id, :videos, null: false, index: true, unique: true

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
