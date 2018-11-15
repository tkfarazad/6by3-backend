# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:stripe_invoice_items) do
      drop_constraint :stripe_invoice_items_stripe_id_key
    end
  end

  down do
    alter_table(:stripe_invoice_items) do
      add_unique_constraint :stripe_id
    end
  end
end
