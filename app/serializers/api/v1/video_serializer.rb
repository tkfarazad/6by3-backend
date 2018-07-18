# frozen_string_literal: true

module Api::V1
  class VideoSerializer < Api::V1::BaseSerializer
    type 'videos'

    attributes :name,
               :content,
               :duration,
               :description

    has_many :coaches do
      linkage always: true
    end
  end
end
