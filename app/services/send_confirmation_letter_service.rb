# frozen_string_literal: true

class SendConfirmationLetterService
  def call(user)
    auth_token = create_auth_token(user)

    send_letter(user, auth_token)
  end

  private

  def create_auth_token(user)
    Sequel::Model.db.transaction do
      touch_user(user)
      generate_auth_token(user)
    end
  end

  def touch_user(user)
    user.update(
      email_confirmation_token:        SecureRandom.uuid,
      email_confirmation_requested_at: Time.current
    )
  end

  def generate_auth_token(user)
    ::AuthToken.create(user: user, token: SecureRandom.uuid)
  end

  def send_letter(user, auth_token)
    ::UserMailer.with(user_id: user.id, auth_token_id: auth_token.id).confirmation.deliver_later
  end
end
