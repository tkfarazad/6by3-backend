# frozen_string_literal: true

module Api::V1::Subscriptions
  class CancelController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do |subscription|
          render jsonapi: subscription
        end
      end
    end
  end
end
