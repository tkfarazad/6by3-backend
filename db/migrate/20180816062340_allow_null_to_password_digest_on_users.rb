# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :users do
      set_column_allow_null :password_digest
    end
  end
end
