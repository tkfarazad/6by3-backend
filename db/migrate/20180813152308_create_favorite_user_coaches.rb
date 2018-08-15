# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :favorite_user_coaches do
      primary_key :id

      unique %i[user_id coach_id]

      foreign_key :user_id, :users, null: false, index: true
      foreign_key :coach_id, :coaches, null: false, index: true

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
