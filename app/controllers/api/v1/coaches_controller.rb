# frozen_string_literal: true

module Api::V1
  class CoachesController < ::Api::V1::ApplicationController
    def index
      api_action do |m|
        m.success do |coaches, meta|
          render jsonapi: coaches,
                 meta: meta
        end
      end
    end

    def show
      api_action do |m|
        m.success do |coach|
          render jsonapi: coach
        end
      end
    end
  end
end
