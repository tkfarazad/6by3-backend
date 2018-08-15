# frozen_string_literal: true

module Api::V1::User::Relationships
  class FavoriteCoachesController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do
          head 201
        end
      end
    end

    def destroy
      api_action do |m|
        m.success do
          head :no_content
        end
      end
    end
  end
end
