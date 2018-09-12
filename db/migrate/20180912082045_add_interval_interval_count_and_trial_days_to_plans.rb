# frozen_string_literal: true

Sequel.migration do
  no_transaction

  up do
    alter_table :stripe_plans do
      add_column :interval, String
      add_column :interval_count, Integer
      add_column :trial_period_days, Integer
    end

    run(<<-SQL.squish)
      UPDATE stripe_plans SET interval = 'temp', interval_count = 0;
    SQL

    alter_table :stripe_plans do
      set_column_not_null :interval
      set_column_not_null :interval_count
    end
  end

  down do
    alter_table :stripe_plans do
      drop_column :interval
      drop_column :interval_count
    end
  end
end
