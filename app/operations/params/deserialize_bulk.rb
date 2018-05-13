# frozen_string_literal: true

module Params
  class DeserializeBulkJsonapi < BaseOperation
    attr_accessor :deserializer
    private       :deserializer

    def initialize(deserializer: Api::V1::BaseDeserializer)
      self.deserializer = deserializer
    end

    def call(input)
      input = input.dig(:_jsonapi)
      JSONAPI.parse_response!(input)

      return [] unless input[:data].is_a?(Array)

      input[:data].each_with_object([]) do |entity, result|
        result << ::Api::V1::BaseDeserializer.call(entity)
      end
    end
  end
end
