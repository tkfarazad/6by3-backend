# frozen_string_literal: true

module Api::V1::SC::Billing::Stripe
  class ProductSerializer < Api::V1::BaseSerializer
    type 'products'

    attributes :id,
               :name,
               :stripe_id
  end
end
