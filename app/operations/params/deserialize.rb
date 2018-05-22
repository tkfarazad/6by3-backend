# frozen_string_literal: true

module Params
  class Deserialize < BaseOperation
    attr_accessor :deserializer
    private       :deserializer

    def initialize(deserializer: Api::V1::BaseDeserializer)
      self.deserializer = deserializer
    end

    def call(input, skip_validation: false)
      input = input.fetch(:_jsonapi, {})
      JSONAPI.parse_resource!(input) unless skip_validation

      deserializer.call(input.fetch(:data, {}))
    end
  end
end
