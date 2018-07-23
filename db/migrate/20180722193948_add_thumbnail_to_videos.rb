# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :videos do
      add_column :thumbnail, String
    end
  end
end
