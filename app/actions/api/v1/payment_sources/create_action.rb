# frozen_string_literal: true

module Api::V1::PaymentSources
  class CreateAction < ::Api::V1::BaseAction
    map :deserialize, with: 'params.deserialize'
    step :validate, with: 'params.validate'
    step :create_customer_if_not_exists
    step :create

    def deserialize(input)
      super(input, skip_validation: true)
    end

    private

    def create_customer_if_not_exists(input)
      return Success(input) if current_user.stripe_customer_id.present?

      result = create_customer

      if result.success?
        Success(input)
      else
        Failure(result)
      end
    end

    def create(token:)
      ::SC::Billing::Stripe::PaymentSources::CreateOperation.new.call(current_user, token).to_result
    end

    def create_customer
      ::SC::Billing::Stripe::Customers::CreateOperation.new.call(current_user)
    end
  end
end
