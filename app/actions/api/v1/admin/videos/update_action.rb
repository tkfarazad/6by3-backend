# frozen_string_literal: true

module Api::V1::Admin::Videos
  class UpdateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:video]

    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :update, catch: Sequel::InvalidOperation

    private

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    def find(input)
      context[:video] = ::Video.with_pk!(input.fetch(:id))

      input
    end

    def validate(input)
      super(input, resolve_schema)
    end

    def update(input)
      ::Videos::UpdateOperation.new(video).call(input)
    end

    def can?
      resolve_policy.new(current_user).update?
    end
  end
end
