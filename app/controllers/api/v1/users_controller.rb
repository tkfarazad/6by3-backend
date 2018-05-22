# frozen_string_literal: true

module Api::V1
  class UsersController < ::Api::V1::ApplicationController
    skip_before_action :authenticate_user, only: %i[create]

    def create
      api_action do |m|
        m.success do |user|
          render jsonapi: user, status: :created
        end

        m.failure(:create) do
          head 409
        end
      end
    end
  end
end
