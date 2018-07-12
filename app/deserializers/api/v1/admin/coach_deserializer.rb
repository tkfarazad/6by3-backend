# frozen_string_literal: true

module Api::V1::Admin
  class CoachDeserializer < ::Api::V1::BaseDeserializer
    has_many do |_, video_ids|
      { video_pks: video_ids }
    end
  end
end
