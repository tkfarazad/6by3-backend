# frozen_string_literal: true

module EntityFinder
  class Bulk < BaseOperation
    def call(input, entity_type:)
      input.each_with_object([]) do |entity, result|
        result << entity_type.with_pk!(entity.fetch(:id))
      end
    end
  end
end
