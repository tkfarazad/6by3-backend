# frozen_string_literal: true

module Api::V1::Admin::Users
  class DestroyAction < ::Api::V1::BaseAction
    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    tee :cancel_subscription
    map :destroy
    tee :notify

    private

    def find(input)
      ::User.with_pk!(input.fetch(:id))
    end

    def cancel_subscription(user)
      user.subscriptions.each do |subscription|
        ::SC::Billing::Stripe::Subscriptions::CancelOperation.new.call(subscription)
      end
    end

    def destroy(user)
      ::SoftDestroyEntityOperation.new(user).call
    end

    def notify(user)
      ::AdminMailer
        .with(user_id: user.id, name: user.first_name)
        .customer_deleted_user_mail
        .deliver_later

      ::AdminMailer
        .with(user_id: user.id, name: user.full_name)
        .customer_deleted_admin_mail
        .deliver_later
    end
  end
end
