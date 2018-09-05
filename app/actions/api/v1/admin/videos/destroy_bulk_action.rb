# frozen_string_literal: true

module Api::V1::Admin::Videos
  class DestroyBulkAction < ::Api::V1::BaseAction
    step :authorize
    try :deserialize_bulk, with: 'params.deserialize_bulk', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :find_all, with: 'entity_finder.bulk', catch: Sequel::NoMatchingRow
    array_map :destroy, transaction: true

    private

    def find_all(input)
      super(input, entity_type: ::Video)
    end

    def destroy(video)
      ::SoftDestroyEntityOperation.new(video).call
    end
  end
end
