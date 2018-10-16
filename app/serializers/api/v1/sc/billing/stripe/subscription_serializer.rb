# frozen_string_literal: true

module Api::V1::SC::Billing::Stripe
  class SubscriptionSerializer < Api::V1::BaseSerializer
    type 'subscriptions'

    attributes :id,
               :current_period_start_at,
               :current_period_end_at,
               :trial_start_at,
               :trial_end_at,
               :status,
               :cancel_at_period_end,
               :canceled_at,
               :created_at,
               :updated_at

    belongs_to :user
    has_many :plans
    has_many :products
  end
end
