# frozen_string_literal: true

module Filterable
  private

  def apply_filters(scope, filter)
    validate_filtering_keys

    build_filtering_records(scope, filter)
  end

  def validate_filtering_keys
    raise ArgumentError, 'Filtering is not available!' unless self.class.const_defined?(:AVAILABLE_FILTERING_KEYS)
  end

  def build_filtering_records(scope, filter)
    sliced_filters = filter.slice(*self.class::AVAILABLE_FILTERING_KEYS)

    sliced_filters.each_pair do |field, value|
      scope = send('filter_by', scope: scope, field: field, value: value)
    end

    scope
  end
end
