# frozen_string_literal: true

module Api::V1::Subscriptions::Estimate
  class CreateAction < ::Api::V1::Subscriptions::CreateAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow
    map :prepare_subscription_params
    step :create

    private

    def create(subscription_params)
      SC::Billing::Stripe::Subscriptions::EstimateOperation
        .new
        .call(current_user, subscription_params)
        .to_result
    end
  end
end
