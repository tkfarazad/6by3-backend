# frozen_string_literal: true

module Api::V1::PaymentSources::MakeDefault
  class CreateAction < ::Api::V1::BaseAction
    try  :find, catch: Sequel::NoMatchingRow
    step :authorize
    step :make_default

    private

    def find(input)
      ::SC::Billing::Stripe::PaymentSource.with_pk!(input.fetch(:payment_source_id))
    end

    def authorize(payment_source)
      ::Api::V1::PaymentSourcePolicy.new(current_user, payment_source).to_monad(&:make_default?)
    end

    def make_default(payment_source)
      SC::Billing::Stripe::PaymentSources::MakeDefaultOperation.new.call(payment_source).to_result
    end
  end
end
