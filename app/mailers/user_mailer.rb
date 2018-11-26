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

    mail to: @user.email, subject: 'Welcome to 6by3! Confirm Your Email.'
  end

  def reset_password
    @user = User.with_pk!(params.fetch(:user_id))
    @name = @user.full_name

    params = {
      reset_token: @user.reset_password_token
    }

    @change_password_link = "#{site_url}/change_password?#{params.to_query}"

    mail to: @user.email, subject: 'Password Reset'
  end

  def contact_us
    @name = params.fetch(:name)
    @message = params.fetch(:message)

    mail to: 'support@6by3studio.com', from: params.fetch(:email), subject: '6by3 - Contact Us'
  end

  def free_user_created
    @name = params.fetch(:name)

    mail to: params.fetch(:email), subject: 'Your Free Account with 6by3'
  end

  def monthly_subscription_paid
    @name = params.fetch(:first_name)
    @price = params.fetch(:price)

    mail to: params.fetch(:email), subject: 'Your Monthly Purchase'
  end

  def annual_subscription_paid
    @name = params.fetch(:first_name)
    @price = params.fetch(:price)

    mail to: params.fetch(:email), subject: 'Your Annual Purchase'
  end

  def free_trial_start
    @first_payment_date = params.fetch(:first_payment_date)
    @next_payment_date = params.fetch(:next_payment_date)

    mail to: params.fetch(:email), subject: 'Enjoy your 7 day free trial'
  end

  def subscription_cancelled
    @name = params.fetch(:name)
    @end_date = params.fetch(:end_date)

    mail to: params.fetch(:email), subject: '6by3 Cancellation Confirmation'
  end
end
