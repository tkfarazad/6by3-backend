# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum

    create_enum :users_plan_types, %w[free trial paid]

    alter_table :users do
      add_column :plan_type, :users_plan_types
      add_index :plan_type
    end
  end

  down do
    extension :pg_enum

    alter_table :users do
      drop_column :plan_type
    end

    drop_enum :users_plan_types
  end
end
