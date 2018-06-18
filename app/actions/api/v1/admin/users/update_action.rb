# frozen_string_literal: true

module Api::V1::Admin::Users
  class UpdateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:user]

    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :update, catch: Sequel::InvalidOperation

    def find(input)
      context[:user] = ::User.with_pk!(input.fetch(:id))

      input
    end

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    def validate(input)
      super(input, resolve_schema)
    end

    def update(input)
      ::Users::UpdateOperation.new(user).call(input)
    end

    private

    def can?
      resolve_policy.new(current_user).update?
    end
  end
end
