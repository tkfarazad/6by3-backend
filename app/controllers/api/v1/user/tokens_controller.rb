# frozen_string_literal: true

module Api::V1::User
  class TokensController < ::Api::V1::ApplicationController
    skip_before_action :authenticate_user

    def create
      api_action do |m|
        m.success do |token|
          render json: {jwt: token}, status: :created
        end

        m.failure(:authenticate) do
          head 404
        end
      end
    end
  end
end
