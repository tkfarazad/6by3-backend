# frozen_string_literal: true

module Api::V1::Admin::Coaches
  class UpdateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:coach]

    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :update, catch: Sequel::InvalidOperation

    private

    def find(input)
      context[:coach] = ::Coach.with_pk!(input.fetch(:id))

      input
    end

    def authorize(input)
      resolve_policy.new(current_user).to_monad(input, &:update?)
    end

    def update(input)
      ::Coaches::UpdateOperation.new(coach).call(input)
    end
  end
end
