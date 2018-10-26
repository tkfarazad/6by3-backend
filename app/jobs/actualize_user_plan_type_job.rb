# frozen_string_literal: true

class ActualizeUserPlanTypeJob < ApplicationJob
  def perform(subscription_id:)
    subscription = ::SC::Billing::Stripe::Subscription.with_pk!(subscription_id)

    ActualizeUserPlanTypeService.new.call(subscription)
  end
end
