# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :videos do
      add_column :views_count, Integer, default: 0, null: false
    end

    pgt_counter_cache(
      :videos,
      :id,
      :views_count,
      :video_views,
      :video_id,
      trigger_name: :set_views_count,
      function_name: :videos_set_views_count
    )
  end

  down do
    drop_trigger :videos, :set_views_count
    drop_function :videos_set_views_count
    drop_column :videos, :views_count
  end
end
