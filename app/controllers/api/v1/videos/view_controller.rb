# frozen_string_literal: true

module Api::V1::Videos
  class ViewController < ::Api::V1::ApplicationController
    def create
      api_action do |m|
        m.success do
          head 202
        end

        m.failure(:create) do
          head 202
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
