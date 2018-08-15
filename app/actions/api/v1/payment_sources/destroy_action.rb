# frozen_string_literal: true

module Api::V1::PaymentSources
  class DestroyAction < ::Api::V1::BaseAction
    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    step :destroy

    private

    def find(input)
      ::SC::Billing::Stripe::PaymentSource.with_pk!(input.fetch(:id))
    end

    def authorize(payment_source)
      ::Api::V1::PaymentSourcePolicy.new(current_user, payment_source).to_monad(&:destroy?)
    end

    def destroy(payment_source)
      ::SC::Billing::Stripe::PaymentSources::DestroyOperation.new.call(payment_source).to_result
    end
  end
end
