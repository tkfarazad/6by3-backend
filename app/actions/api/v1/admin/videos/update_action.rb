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
      resolve_policy.new(current_user).to_monad(input, &:update?)
    end

    def find(input)
      context[:video] = ::Video.with_pk!(input.fetch(:id))

      input
    end

    def update(input)
      ::Videos::UpdateOperation.new(video).call(input)
    end
  end
end
