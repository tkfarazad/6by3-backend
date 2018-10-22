# frozen_string_literal: true

class SendCustomerDeletedLetterService
  def call(user)
    send_user_letter(user)

    # FIXME: Fails in tests
    # send_admin_letter(user)
  end

  private

  def send_user_letter(user)
    ::UserMailer.with(user_id: user.id, name: user.first_name).customer_deleted_user_mail.deliver_later
  end

  def send_admin_letter(user)
    ::UserMailer.with(user_id: user.id, name: user.full_name).customer_deleted_admin_mail.deliver_later
  end
end
