# frozen_string_literal: true

module JSONAPI
  module Rails
    class SequelErrorsSerializer
      attr_reader :error
      private :error

      def initialize(exposures)
        @error = exposures[:object]

        freeze
      end

      def as_jsonapi
        key = 'data'

        SerializableActiveModelError
          .new(field: key, message: error.message, pointer: "/data/attributes/#{key}")
          .as_jsonapi
      end
    end
  end
end
