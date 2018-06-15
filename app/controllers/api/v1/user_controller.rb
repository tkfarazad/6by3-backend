# frozen_string_literal: true

module Api::V1
  class UserController < ::Api::V1::ApplicationController
    def show
      render jsonapi: current_user
    end

    def update
      api_action do |m|
        m.success do |updated_user|
          render jsonapi: updated_user
        end

        m.failure(:validate) do |errors|
          responds_with_errors(errors, status: :bad_request)
        end
      end
    end

    def destroy
      api_action(input: current_user) do |m|
        m.success do
          head :no_content
        end
      end
    end
  end
end
