# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :auth_tokens do
      primary_key :id

      String :token, null: false, unique: true
      foreign_key :user_id, :users, null: false
      index :user_id

      DateTime :created_at, null: false
    end
  end
end
