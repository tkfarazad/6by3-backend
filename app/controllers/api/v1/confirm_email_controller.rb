# frozen_string_literal: true

module Api::V1
  class ConfirmEmailController < ::Api::V1::ApplicationController
    skip_before_action :authenticate_user, only: %i[create]

    def create
      api_action do |m|
        m.failure(:check_not_found) do |errors|
          responds_with_errors(errors, status: 404)
        end

        m.success do
          head 200
        end
      end
    end
  end
end
