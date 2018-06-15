# frozen_string_literal: true

class UserMailer < ApplicationMailer
  delegate :site_url, to: :'Rails.configuration'

  def confirmation
    @user = User.with_pk!(params.fetch(:user_id))
    @auth_token = AuthToken.with_pk!(params.fetch(:auth_token_id))
    params = {
      confirmation_token: @user.email_confirmation_token,
      auth_token: @auth_token.token
    }

    @confirmation_link = "#{site_url}/confirm?#{params.to_query}"

    mail to: @user.email, subject: 'Email confirmation'
  end

  def reset_password
    @user = User.with_pk!(params.fetch(:user_id))
    params = {
      reset_token: @user.reset_password_token
    }

    @change_password_link = "#{site_url}/change_password?#{params.to_query}"

    mail to: @user.email, subject: 'Reset password'
  end
end
