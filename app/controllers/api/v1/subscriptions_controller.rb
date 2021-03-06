# frozen_string_literal: true

module Api::V1
  class SubscriptionsController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do |subscription|
          render jsonapi: subscription, status: 201
        end

        m.failure(:check_processable) do
          head 422
        end
      end
    end
  end
end
