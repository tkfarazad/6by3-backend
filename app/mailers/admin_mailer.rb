# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  default to: -> { Rails.application.config.support_email_addresses.split(',') }

  def customer_deleted_user_mail
    @name = params.fetch(:name)
    @user = User.with_pk!(params.fetch(:user_id))

    mail to: @user.email, from: 'support@6by3studio.com', subject: '6by3 Studio Subscription Cancelled by Administrator'
  end

  def customer_deleted_admin_mail
    @name = params.fetch(:name)

    mail subject: '6by3 Subscription Cancelled by Admin'
  end
end
