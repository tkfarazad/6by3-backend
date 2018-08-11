# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :videos do
      add_column :url, String, null: false
      add_column :content_type, String, null: false

      drop_column :content

      set_column_allow_null :duration
    end
  end

  down do
    alter_table :videos do
      add_column :content, String, null: false

      drop_column :url
      drop_column :content_type

      set_column_not_null :duration
    end
  end
end
