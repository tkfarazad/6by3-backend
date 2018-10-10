# frozen_string_literal: true

class CreateCustomerService
  def call(user)
    return if user.stripe_customer_id.present?

    ::SC::Billing::Stripe::Customers::CreateOperation.new.call(user)
  end
end
