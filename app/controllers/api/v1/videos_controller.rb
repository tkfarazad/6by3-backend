# frozen_string_literal: true

module Api::V1
  class VideosController < ::Api::V1::ApplicationController
    def index
      api_action do |m|
        m.success do |videos, meta|
          render jsonapi: videos,
                 meta: meta
        end
      end
    end

    def show
      api_action do |m|
        m.success do |video|
          render jsonapi: video
        end
      end
    end
  end
end
