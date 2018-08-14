# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :videos do
      add_column :featured, FalseClass, null: false, default: false
    end
  end
end
