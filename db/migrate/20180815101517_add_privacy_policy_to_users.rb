# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :users do
      add_column :privacy_policy_accepted, FalseClass, null: false, default: false
    end
  end
end
