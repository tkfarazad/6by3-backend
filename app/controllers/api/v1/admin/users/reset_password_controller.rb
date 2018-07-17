# frozen_string_literal: true

module Api::V1::Admin::Users
  class ResetPasswordController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do
          head 202
        end
      end
    end
  end
end
