# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum

    create_enum(
      :users_created_in_types,
      %w[admin signup stripe]
    )

    alter_table :users do
      add_column :created_in, :users_created_in_types
    end
  end

  down do
    extension :pg_enum

    alter_table :users do
      drop_column :created_in
    end

    drop_enum :users_created_in_types
  end
end
