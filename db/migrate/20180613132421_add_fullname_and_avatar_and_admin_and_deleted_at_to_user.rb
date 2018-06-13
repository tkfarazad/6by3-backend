# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :users do
      add_column :fullname, String
      add_column :avatar, String
      add_column :admin, FalseClass, null: false, default: false
      add_column :deleted_at, DateTime
    end
  end
end
