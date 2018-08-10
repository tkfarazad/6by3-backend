# frozen_string_literal: true

module Api::V1
  class VideoCategoriesController < ::Api::V1::ApplicationController
    skip_before_action :authenticate_user, only: %i[index show]

    def index
      api_action do |m|
        m.success do |categories, meta|
          render jsonapi: categories,
                 meta: meta
        end
      end
    end

    def show
      api_action do |m|
        m.success do |category|
          render jsonapi: category
        end
      end
    end
  end
end
