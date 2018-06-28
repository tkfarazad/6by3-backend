# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :coaches do
      primary_key :id

      String :fullname, null: false
      String :avatar
      String :personal_info

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      DateTime :deleted_at
    end
  end
end
