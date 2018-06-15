# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :users do
      add_column :reset_password_token, String, unique: true
      add_column :reset_password_requested_at, DateTime
    end
  end
end
