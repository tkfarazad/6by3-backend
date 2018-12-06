# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :stripe_invoices do
      set_column_allow_null :user_id
    end
  end

  down do
    alter_table :stripe_invoices do
      set_column_not_null :user_id
    end
  end
end
