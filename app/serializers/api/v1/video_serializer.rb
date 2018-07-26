# frozen_string_literal: true

module Api::V1
  class VideoSerializer < Api::V1::BaseSerializer
    type 'videos'

    attributes :name,
               :content,
               :duration,
               :thumbnail,
               :lesson_date,
               :description

    has_many :coaches do
      linkage always: true
    end

    has_one :category do
      linkage always: true
    end

    meta do
      {
        views_count: @object.views_dataset.count
      }
    end
  end
end
