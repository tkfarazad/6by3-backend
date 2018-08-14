# frozen_string_literal: true

module Api::V1::Sockets
  class AuthController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do |auth_key|
          render json: auth_key
        end
      end
    end
  end
end
