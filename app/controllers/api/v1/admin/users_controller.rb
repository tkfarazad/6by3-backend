# frozen_string_literal: true

module Api::V1::Admin
  class UsersController < ::Api::V1::ApplicationController
    def index
      api_action do |m|
        m.success do |users|
          render jsonapi: users
        end

        m.failure(:authorize) do
          head 403
        end
      end
    end

    def create
      api_action do |m|
        m.success do |user|
          render jsonapi: user, status: :created
        end

        m.failure(:create) do
          head 409
        end

        m.failure(:authorize) do
          head 403
        end
      end
    end

    def update
      api_action do |m|
        m.success do |updated_user|
          render jsonapi: updated_user
        end

        m.failure(:authorize) do
          head 403
        end
      end
    end

    def destroy
      api_action do |m|
        m.success do
          head :no_content
        end

        m.failure(:authorize) do
          head 403
        end
      end
    end
  end
end
