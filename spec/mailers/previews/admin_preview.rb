# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin

class AdminPreview < ActionMailer::Preview
  def customer_deleted_user_mail
    user = ::FactoryBot.create(:user)

    AdminMailer.with(user_id: user.id, name: user.first_name).customer_deleted_user_mail
  end
end
