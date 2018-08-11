# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :videos do
      add_column :state, String, null: false
    end
  end

  down do
    alter_table :videos do
      drop_column :state
    end
  end
end
