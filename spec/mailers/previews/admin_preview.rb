# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin

class AdminPreview < ActionMailer::Preview
  def customer_deleted_user_mail
    user = ::FactoryBot.create(:user)

    AdminMailer.with(user_id: user.id, name: user.first_name).customer_deleted_user_mail
  end

  def customer_deleted_admin_mail
    user = ::FactoryBot.create(:user)

    AdminMailer.with(user_id: user.id, name: user.full_name).customer_deleted_admin_mail
  end

  def free_trial_user_created
    user = ::FactoryBot.create(:user)

    AdminMailer
      .with(email: user.email, full_name: user.full_name)
      .free_trial_user_created
  end

  def user_first_monthly_subscription_paid
    user = ::FactoryBot.create(:user)

    # TODO: Add some price
    AdminMailer
      .with(email: user.email, full_name: user.full_name, price: 1)
      .user_first_monthly_subscription_paid
  end

  def user_first_annual_subscription_paid
    user = ::FactoryBot.create(:user)

    # TODO: Add some price
    AdminMailer
      .with(email: user.email, full_name: user.full_name, price: 1)
      .user_first_annual_subscription_paid
  end

  def subscription_cancelled
    user = ::FactoryBot.create(:user)

    # TODO: Add some price
    # TODO: subscription_type: (Monthly or Annual)
    AdminMailer
      .with(email: user.email, full_name: user.full_name, price: 1, subscription_type: 'annual')
      .subscription_cancelled
  end
end
