# frozen_string_literal: true

module Api::V1
  module PaymentSources
    class MakeDefaultController < ApplicationController
      def create
        api_action do |m|
          m.success do
            head 200
          end
        end
      end
    end
  end
end
