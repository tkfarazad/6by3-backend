# frozen_string_literal: true

module Api::V1
  class VideoCategorySerializer < Api::V1::BaseSerializer
    type 'categories'

    attribute :name
  end
end
