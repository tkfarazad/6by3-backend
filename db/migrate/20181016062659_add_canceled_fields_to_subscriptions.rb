# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :stripe_subscriptions do
      add_column :cancel_at_period_end, FalseClass
      add_column :canceled_at, DateTime
    end

    run(<<-SQL.squish)
      UPDATE stripe_subscriptions SET cancel_at_period_end = false;
    SQL

    alter_table :stripe_subscriptions do
      set_column_not_null :cancel_at_period_end
    end
  end

  down do
    alter_table :stripe_subscriptions do
      drop_column :cancel_at_period_end
      drop_column :canceled_at
    end
  end
end
