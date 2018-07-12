# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :coaches_videos do
      primary_key :id

      unique %i[coach_id video_id]

      foreign_key :coach_id, :coaches, null: false, index: true
      foreign_key :video_id, :videos, null: false, index: true

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
