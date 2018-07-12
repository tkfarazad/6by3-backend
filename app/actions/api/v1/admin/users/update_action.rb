# frozen_string_literal: true

module Api::V1::Admin::Users
  class UpdateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:user]

    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :update, catch: Sequel::InvalidOperation

    private

    def find(input)
      context[:user] = ::User.with_pk!(input.fetch(:id))

      input
    end

    def update(input)
      ::Users::UpdateOperation.new(user).call(input)
    end
  end
end
