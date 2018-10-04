# frozen_string_literal: true

module Api::V1::Plans
  class IndexAction < ::Api::V1::BaseAction
    map :build_response

    private

    def build_response
      [::SC::Billing::Stripe::Plan.applicable.all, nil]
    end
  end
end
