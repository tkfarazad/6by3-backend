# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  default to: -> { Rails.application.config.support_email_addresses.split(',') }

  def customer_deleted_user_mail
    @name = params.fetch(:name)
    @user = User.with_pk!(params.fetch(:user_id))

    mail to: @user.email, from: 'support@6by3studio.com', subject: '6by3 Subscription Cancelled by Admin'
  end

  def customer_deleted_admin_mail
    @name = params.fetch(:name)

    mail subject: '6by3 Subscription Cancelled by Admin'
  end

  def free_trial_user_created
    @name = params.fetch(:name)
    @email = params.fetch(:email)

    mail subject: 'New User Registered on Free 7 Days Trial'
  end

  def user_first_monthly_transaction
    @name = params.fetch(:name)
    @email = params.fetch(:email)
    @price = params.fetch(:price)

    mail subject: 'Monthly subscription fee successfully charged'
  end

  def user_first_annual_transaction
    @name = params.fetch(:name)
    @email = params.fetch(:email)
    @price = params.fetch(:price)

    mail subject: 'Annual subscription fee successfully charged'
  end

  def subscription_cancelled
    @name = params.fetch(:name)
    @email = params.fetch(:email)
    @price = params.fetch(:price)
    @subscription_type = params.fetch(:subscription_type)

    mail subject: 'Subscription Cancelled'
  end
end