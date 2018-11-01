# frozen_string_literal: true

class AdminMailer < ApplicationMailer
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
