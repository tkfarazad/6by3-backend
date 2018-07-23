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

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def update(input)
      ::UpdateEntityOperation.new(coach).call(input)
    end
  end
end
