# frozen_string_literal: true

module Api::V1
  class ChangePasswordController < ::Api::V1::ApplicationController
    skip_before_action :authenticate_user, only: %i[create]

    def create
      api_action do |m|
        m.success do
          head 200
        end

        m.failure(:check_processable) do
          head 404
        end
      end
    end
  end
end
