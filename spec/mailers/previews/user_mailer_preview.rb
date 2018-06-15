# frozen_string_literal: true

# Preview all emails at http://localhost:3001/rails/mailers/user

class UserMailerPreview < ActionMailer::Preview
  def confirmation
    user = ::FactoryBot.create(:user, :unconfirmed)
    auth_token = ::AuthToken.create(user: user, token: SecureRandom.uuid)

    UserMailer.with(user_id: user.id, auth_token_id: auth_token.id).confirmation
  end

  def reset_password
    user = ::FactoryBot.create(:user, :reset_password_requested)

    UserMailer.with(user_id: user.id).reset_password
  end
end
