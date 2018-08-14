# frozen_string_literal: true

module Api::V1
  class VideosController < ::Api::V1::ApplicationController
    include ::ShowableConcern
  end
end
