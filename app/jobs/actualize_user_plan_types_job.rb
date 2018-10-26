# frozen_string_literal: true

class ActualizeUserPlanTypesJob < ApplicationJob
  def perform
    ::SC::Billing::Stripe::Subscription.order(:id).paged_each do |subscription|
      ActualizeUserPlanTypeJob.perform_later(subscription_id: subscription.id)
    end
  end
end
