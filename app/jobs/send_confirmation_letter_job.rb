# frozen_string_literal: true

class SendConfirmationLetterJob < ApplicationJob
  def perform(user_id:)
    user = User.with_pk!(user_id)

    SendConfirmationLetterService.new.call(user)
  end
end
