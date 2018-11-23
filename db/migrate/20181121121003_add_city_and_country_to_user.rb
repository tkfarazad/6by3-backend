# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :users do
      add_column :city, String
      add_column :country, String
    end
  end

  down do
    alter_table :users do
      drop_column :city
      drop_column :country
    end
  end
end
