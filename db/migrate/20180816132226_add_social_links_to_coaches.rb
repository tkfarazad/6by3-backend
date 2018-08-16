# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :coaches do
      add_column :social_links, :jsonb, null: false, default: {}.to_json
    end
  end
end
