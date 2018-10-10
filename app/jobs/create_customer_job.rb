# frozen_string_literal: true

class CreateCustomerJob < ApplicationJob
  queue_as :subscriptions

  def perform(user_id:)
    user = User.with_pk!(user_id)

    CreateCustomerService.new.call(user)
  end
end
