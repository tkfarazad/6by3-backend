# frozen_string_literal: true

module Api::V1::Users
  class CreateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:request]

    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::Error
    tee :enqueue_jobs

    private

    def create(input)
      user = ::User.find(email: input.fetch(:email))

      if user && user.password_digest.nil?
        ::UpdateEntityOperation.new(user).call(input)
      else
        ::User.create(input.merge(created_in: User::USERS_CREATED_IN_SIGNUP_TYPE))
      end
    end

    def enqueue_jobs(user)
      ::SendConfirmationLetterJob.perform_later(user_id: user.id)
      ::CreateCustomerJob.perform_later(user_id: user.id)
      ::LocateUserJob.perform_later(user_id: user.id, ip_addr: request.remote_ip)
      ::Customerio::IdentifyUserJob.perform_later(user_id: user.id)
    end
  end
end
