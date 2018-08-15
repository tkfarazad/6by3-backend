# frozen_string_literal: true

module Api::V1
  class SubscriptionsController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do |payment_source|
          render jsonapi: payment_source, status: 201
        end
      end
    end
  end
end
