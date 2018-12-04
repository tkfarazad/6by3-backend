# frozen_string_literal: true

module Api::V1::Admin::Users
  class DestroyBulkAction < ::Api::V1::BaseAction
    step :authorize
    try :deserialize_bulk, with: 'params.deserialize_bulk', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :find_all, with: 'entity_finder.bulk', catch: Sequel::NoMatchingRow
    array_tee :cancel_subscription
    array_map :destroy, transaction: true
    array_tee :notify

    private

    def find_all(input)
      super(input, entity_type: ::User)
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
        .with(user_id: user.id, name: user.full_name)
        .customer_deleted_user_mail
        .deliver_later
    end
  end
end
