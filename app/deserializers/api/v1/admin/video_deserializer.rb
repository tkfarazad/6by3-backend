# frozen_string_literal: true

module Api::V1::Admin
  class VideoDeserializer < ::Api::V1::BaseDeserializer
    has_many do |_, coach_ids|
      { coach_pks: coach_ids }
    end
  end
end
