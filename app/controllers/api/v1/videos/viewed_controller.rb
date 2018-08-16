# frozen_string_literal: true

module Api::V1::Videos
  class ViewedController < ::Api::V1::ApplicationController
    def index
      api_action do |m|
        m.success do |videos, meta|
          render jsonapi: videos,
                 meta: meta
        end
      end
    end
  end
end
