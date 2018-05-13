# frozen_string_literal: true

module JSONAPI
  module Rails
    class DryValidationErrorsSerializer
      attr_reader :dry_result

      private :dry_result

      def initialize(exposures)
        @dry_result = exposures[:object]

        freeze
      end

      def as_jsonapi
        dry_result.errors.keys.flat_map do |key|
          dry_result.errors[key].map do |message|
            SerializableActiveModelError
              .new(field: key, message: message, pointer: "/data/attributes/#{key}")
              .as_jsonapi
          end
        end
      end
    end
  end
end
