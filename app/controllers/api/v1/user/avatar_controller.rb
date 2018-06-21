# frozen_string_literal: true

module Api::V1::User
  class AvatarController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do |updated_user|
          render jsonapi: updated_user
        end
      end
    end

    alias update create
    alias destroy create
  end
end
