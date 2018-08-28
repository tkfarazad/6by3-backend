# frozen_string_literal: true

module Api::V1
  class ContactUsEmailController < ::Api::V1::ApplicationController
    skip_before_action :authenticate_user, only: %i[create]

    def create
      api_action do |m|
        m.success do
          head 200
        end
      end
    end
  end
end
