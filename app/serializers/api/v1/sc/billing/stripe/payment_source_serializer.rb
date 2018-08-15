# frozen_string_literal: true

module Api::V1::SC::Billing::Stripe
  class PaymentSourceSerializer < Api::V1::BaseSerializer
    type 'paymentSources'

    attributes :id,
               :type,
               :status,
               :stripe_id,
               :stripe_data

    attribute :object do
      @object.object
    end
  end
end
