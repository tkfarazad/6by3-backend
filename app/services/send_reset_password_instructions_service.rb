# frozen_string_literal: true

class SendResetPasswordInstructionsService
  def call(user)
    touch_user(user)
    send_letter(user)
  end

  private

  def touch_user(user)
    user.update(
      reset_password_token: SecureRandom.uuid,
      reset_password_requested_at: Time.current
    )
  end

  def send_letter(user)
    ::UserMailer.with(user_id: user.id).reset_password.deliver_later
  end
end
