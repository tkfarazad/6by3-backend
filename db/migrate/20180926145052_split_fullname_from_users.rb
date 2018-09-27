# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :users do
      add_column :first_name, String
      add_column :last_name, String

      drop_column :fullname
    end
  end

  down do
    alter_table :users do
      add_column :fullname, String

      drop_column :first_name
      drop_column :last_name
    end
  end
end
