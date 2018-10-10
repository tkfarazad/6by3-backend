# frozen_string_literal: true

module Api::V1::PaymentSources
  class CreateAction < ::Api::V1::BaseAction
    map :deserialize, with: 'params.deserialize'
    step :validate, with: 'params.validate'
    step :create

    private

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def create(token:)
      ::SC::Billing::Stripe::PaymentSources::CreateOperation.new.call(current_user, token).to_result
    end
  end
end
