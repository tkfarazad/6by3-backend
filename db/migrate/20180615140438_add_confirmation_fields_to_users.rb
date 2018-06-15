# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :users do
      add_column :email_confirmed_at, DateTime
      add_column :email_confirmation_token, String, unique: true
      add_column :email_confirmation_requested_at, DateTime
    end
  end
end
