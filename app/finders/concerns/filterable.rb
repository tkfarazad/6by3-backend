# frozen_string_literal: true

module Filterable
  private

  def apply_filters(scope, filter)
    validate_filtering_keys

    generate_response(scope, filter)
  end

  def validate_filtering_keys
    raise ArgumentError, 'Filtering is not available!' unless self.class.const_defined?(:AVAILABLE_FILTERING_KEYS)
  end

  def build_filtering_records(scope:, search_params:, field:)
    if search_params.is_a? Hash
      search_params.each do |function, value|
        method_name = "filter_by_#{function}"

        scope = send(method_name, scope: scope, field: field, value: value) if respond_to?(method_name, true)
      end
    else
      scope = send('filter_by_like', scope: scope, field: field, value: search_params)
    end

    scope
  end

  def generate_response(scope, filter)
    sliced_filters = filter.slice(*self.class::AVAILABLE_FILTERING_KEYS)

    sliced_filters.each_pair do |field, search_params|
      scope = build_filtering_records(scope: scope, search_params: search_params, field: field)
    end

    scope
  end
end
