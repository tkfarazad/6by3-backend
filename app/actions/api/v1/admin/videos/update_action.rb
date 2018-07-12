# frozen_string_literal: true

module Api::V1::Admin::Videos
  class UpdateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:video]

    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    try :deserialize, catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :update, catch: Sequel::InvalidOperation

    private

    def find(input)
      context[:video] = ::Video.with_pk!(input.fetch(:id))

      input
    end

    def deserialize(input)
      Params::Deserialize.new(deserializer: ::Api::V1::Admin::VideoDeserializer)
                         .call(input, skip_validation: true)
    end

    def update(input)
      ::Videos::UpdateOperation.new(video).call(input)
    end
  end
end
