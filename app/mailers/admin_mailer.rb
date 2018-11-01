# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def customer_deleted_user_mail
    @name = params.fetch(:name)
    @user = User.with_pk!(params.fetch(:user_id))

    mail to: @user.email, from: 'support@6by3studio.com', subject: '6by3 Subscription Cancelled by Admin'
  end

  def customer_deleted_admin_mail
    @name = params.fetch(:name)

    mail to: 'support@6by3studio.com', subject: '6by3 Subscription Cancelled by Admin'
  end

  def free_trial_user_created
    @name = params.fetch(:name)
    @email = params.fetch(:email)

    mail to: 'support@6by3studio.com', subject: 'New User Registered on Free 7 Days Trial'
  end

  def user_first_monthly_transaction
    @name = params.fetch(:name)
    @email = params.fetch(:email)
    @price = params.fetch(:price)

    mail to: 'support@6by3studio.com', subject: 'Monthly subscription fee successfully charged'
  end

  def user_first_annual_transaction
    @name = params.fetch(:name)
    @email = params.fetch(:email)
    @price = params.fetch(:price)

    mail to: 'support@6by3studio.com', subject: 'Annual subscription fee successfully charged'
  end

  def subscription_cancelled
    @name = params.fetch(:name)
    @email = params.fetch(:email)
    @price = params.fetch(:price)
    @subscription_type = params.fetch(:subscription_type)

    mail to: 'support@6by3studio.com', subject: 'Subscription Cancelled'
  end
end
