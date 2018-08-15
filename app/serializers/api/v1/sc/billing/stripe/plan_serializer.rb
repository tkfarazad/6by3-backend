# frozen_string_literal: true

module Api::V1::SC::Billing::Stripe
  class PlanSerializer < Api::V1::BaseSerializer
    type 'plans'

    attributes :id,
               :name,
               :amount,
               :currency,
               :stripe_id

    belongs_to :product
  end
end
