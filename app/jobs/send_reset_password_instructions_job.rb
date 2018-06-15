# frozen_string_literal: true

class SendResetPasswordInstructionsJob < ApplicationJob
  def perform(user_id:)
    user = User.with_pk!(user_id)

    SendResetPasswordInstructionsService.new.call(user)
  end
end
