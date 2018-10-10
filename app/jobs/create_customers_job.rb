# frozen_string_literal: true

class CreateCustomersJob < ApplicationJob
  queue_as :subscriptions

  def perform
    User.order(:id).paged_each do |user|
      CreateCustomerJob.perform_later(user_id: user.id)
    end
  end
end
