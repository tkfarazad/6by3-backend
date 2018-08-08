# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :videos do
      drop_column :content
      add_column :url, String, null: false

      set_column_allow_null :duration
    end
  end
end
