# frozen_string_literal: true

module Api::V1
  class VideoSerializer < Api::V1::BaseSerializer
    type 'videos'

    attributes :name,
               :content,
               :description

    # BUG: Find a way how to access `duration` from the `carrierwave-video` and `streamio-ffmpeg`
    attribute :duration do
      0
    end

    has_many :coaches do
      linkage always: true
    end
  end
end
