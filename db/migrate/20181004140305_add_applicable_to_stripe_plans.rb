# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :stripe_plans do
      add_column :applicable, :boolean
    end

    run(<<-SQL)
      UPDATE stripe_plans SET applicable = true;
    SQL

    alter_table :stripe_plans do
      set_column_not_null :applicable
    end
  end

  down do
    alter_table :stripe_plans do
      drop_column :applicable
    end
  end
end
