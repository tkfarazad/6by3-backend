# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :videos do
      set_column_type :duration, 'integer USING CAST(duration AS integer)'
    end
  end
end
