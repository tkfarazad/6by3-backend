# frozen_string_literal: true

module Api::V1::Subscriptions
  class EstimateController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do |result|
          render json: result
        end
      end
    end
  end
end
