# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :videos do
      add_column :lesson_date, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      add_foreign_key :category_id, :video_categories, index: true
    end
  end
end
