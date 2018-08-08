# frozen_string_literal: true

module Api::V1::Admin
  class VideosController < ::Api::V1::Admin::BaseController
    IMPLEMENT_METHODS = %i[index show create update destroy].freeze
  end
end
