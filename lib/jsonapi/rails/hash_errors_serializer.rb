# frozen_string_literal: true

module JSONAPI
  module Rails
    class HashErrorsSerializer
      attr_reader :result

      private :result

      def initialize(exposures)
        @result = exposures[:object]

        freeze
      end

      def as_jsonapi
        result.keys.flat_map do |key|
          result[key].map do |message|
            SerializableActiveModelError
              .new(field: key, message: message, pointer: "/data/attributes/#{key}")
              .as_jsonapi
          end
        end
      end
    end
  end
end
