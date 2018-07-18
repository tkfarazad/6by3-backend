# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :videos do
      set_column_not_null :duration
    end
  end
end
