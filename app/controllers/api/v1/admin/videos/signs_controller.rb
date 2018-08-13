# frozen_string_literal: true

module Api::V1::Admin::Videos
  class SignsController < ::Api::V1::ApplicationController
    def show
      api_action do |m|
        m.success do |signed_url|
          render json: {'signedUrl' => signed_url}
        end
      end
    end
  end
end
