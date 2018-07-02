# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :videos do
      primary_key :id

      String :name, null: false
      String :content, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      DateTime :deleted_at
    end
  end
end
