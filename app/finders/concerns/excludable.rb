# frozen_string_literal: true

module Excludable
  private

  def apply_exclusion(scope, exclusion)
    validate_exclusion_keys

    build_exclusion_records(scope, exclusion)
  end

  def validate_exclusion_keys
    raise ArgumentError, 'Excluding is not available!' unless self.class.const_defined?(:AVAILABLE_EXCLUSION_KEYS)
  end

  def build_exclusion_records(scope, exclusion)
    sliced_exclusions = exclusion.slice(*self.class::AVAILABLE_EXCLUSION_KEYS)

    sliced_exclusions.each do |attribute, value|
      case value
      when ::SixByThree::Constants::VALUE_PRESENT
        scope = scope.where(attribute => nil)
      end
    end

    scope
  end
end
