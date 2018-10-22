# frozen_string_literal: true

class SendCustomerDeletedLetterJob < ApplicationJob
  def perform(user_id:)
    user = User.with_pk!(user_id)

    ::SendCustomerDeletedLetterService.new.call(user)
  end
end
