# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin

class AdminPreview < ActionMailer::Preview
  def customer_deleted_user_mail
    user = ::FactoryBot.create(:user)

    UserMailer.with(user_id: user.id, name: user.first_name).customer_deleted_user_mail
  end

  def customer_deleted_admin_mail
    user = ::FactoryBot.create(:user)

    UserMailer.with(user_id: user.id, name: user.full_name).customer_deleted_admin_mail
  end
end
