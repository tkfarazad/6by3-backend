# frozen_string_literal: true

module Api::V1::Users
  class CreateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::Error
    tee :enqueue_jobs

    private

    def create(input)
      user = ::User.find(email: input.fetch(:email))

      if user && user.password_digest.nil?
        user.set(input).save
      else
        ::User.create(input)
      end
    end

    def enqueue_jobs(user)
      SendConfirmationLetterJob.perform_later(user_id: user.id)
      CreateCustomerJob.perform_later(user_id: user.id)
    end
  end
end
