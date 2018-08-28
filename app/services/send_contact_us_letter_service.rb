# frozen_string_literal: true

class SendContactUsLetterService
  def call(params)
    send_letter(params)
  end

  private

  def send_letter(name:, email:, message:)
    ::UserMailer.with(name: name, email: email, message: message).contact_us.deliver_later
  end
end
