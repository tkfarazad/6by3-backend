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

  def contact_us
    user = ::FactoryBot.create(:user)
    message = ::FFaker::Book.description

    UserMailer.with(user_id: user.id, message: message).contact_us
  end

  def customer_deleted_user_mail
    user = ::FactoryBot.create(:user)

    UserMailer.with(user_id: user.id, name: user.first_name).customer_deleted_user_mail
  end

  def customer_deleted_admin_mail
    user = ::FactoryBot.create(:user)

    UserMailer.with(user_id: user.id, name: user.full_name).customer_deleted_admin_mail
  end

  def monthly_subscription_paid
    user = ::FactoryBot.create(:user)

    UserMailer
      .with(email: user.email, name: user.first_name, price: rand(100))
      .monthly_subscription_paid
  end

  def annual_subscription_paid
    user = ::FactoryBot.create(:user)

    UserMailer
      .with(email: user.email, name: user.first_name, price: rand(100))
      .annual_subscription_paid
  end

  def free_trial_start
    UserMailer
      .with(first_payment_date: Time.current.next_week, next_payment_date: Time.current.next_week.next_month)
      .free_trial_start
  end
end
