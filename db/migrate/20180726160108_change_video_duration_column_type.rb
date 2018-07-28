# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :videos do
      set_column_type :duration, 'integer USING ROUND(CAST(duration AS decimal), 0)'
    end
  end

  down do
    alter_table :videos do
      set_column_type :duration, 'text USING CAST(duration AS text)'
    end
  end
end
