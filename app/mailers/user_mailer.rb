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

    mail to: @user.email, subject: 'Confirm Your Email'
  end

  def reset_password
    @user = User.with_pk!(params.fetch(:user_id))
    params = {
      reset_token: @user.reset_password_token
    }

    @change_password_link = "#{site_url}/change_password?#{params.to_query}"

    mail to: @user.email, subject: 'Reset password'
  end

  def contact_us
    @name = params.fetch(:name)
    @message = params.fetch(:message)

    mail to: 'support@6by3studio.com', from: params.fetch(:email), subject: '6by3 - Contact Us'
  end

  def customer_deleted_user_mail
    @name = params.fetch(:name)
    @user = User.with_pk!(params.fetch(:user_id))

    mail to: @user.email, from: 'info@6by3.tv', subject: '6by3 Subscription Cancelled by Admin'
  end

  def customer_deleted_admin_mail
    @name = params.fetch(:name)

    mail to: 'info@6by3.tv', subject: '6by3 Subscription Cancelled by Admin'
  end
end
