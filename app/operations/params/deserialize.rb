# frozen_string_literal: true

module Params
  class Deserialize < BaseOperation
    attr_accessor :deserializer
    private       :deserializer

    def initialize(deserializer: Api::V1::BaseDeserializer)
      self.deserializer = deserializer
    end

    def call(input)
      input = input.dig(:_jsonapi)
      JSONAPI.parse_response!(input)

      deserializer.call(input.fetch(:data))
    end
  end
end
