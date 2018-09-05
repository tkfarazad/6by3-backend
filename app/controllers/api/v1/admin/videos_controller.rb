# frozen_string_literal: true

module Api::V1::Admin
  class VideosController < ::Api::V1::Admin::BaseController
    IMPLEMENT_METHODS = %w[index show create update destroy destroy_bulk].freeze
  end
end
