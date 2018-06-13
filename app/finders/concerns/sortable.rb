# frozen_string_literal: true

module Sortable
  private

  def apply_sorting(scope, sort)
    validate_sorting_keys

    sorting_rules = generate_sorting_rules(sort)

    build_sorting_records(scope, sorting_rules)
  end

  def validate_sorting_keys
    raise ArgumentError, 'Sorting is not available!' unless self.class.const_defined?(:AVAILABLE_SORTING_KEYS)
  end

  def generate_sorting_rules(sort)
    sort.split(',').each_with_object([]) do |sorting_key, rules|
      next unless self.class::AVAILABLE_SORTING_KEYS.include?(sorting_key)

      rules <<
        if sorting_key.start_with?('-')
          Sequel.desc(sorting_key[1..-1].to_sym)
        else
          Sequel.asc(sorting_key.to_sym)
        end
    end
  end

  def build_sorting_records(scope, sorting_rules)
    sorting_rules.any? ? scope.order(*sorting_rules) : scope
  end
end
