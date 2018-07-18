# frozen_string_literal: true

Sequel.migration do
  change do
    add_column :coaches, :certifications, "text[]"
  end
end
