# frozen_string_literal: true

class BaseFinder
  def initialize(initial_scope:)
    @initial_scope = initial_scope
  end

  def call(filter: false, sort: false, paginate: false, exclude: false)
    scope = initial_scope
    scope = apply_exclusion(scope, exclude) if exclude
    scope = apply_filters(scope, filter) if filter
    scope = apply_sorting(scope, sort) if sort
    scope = apply_pagination(scope, paginate) if paginate
    scope
  end

  private

  CUSTOM_FILTERS = {}.freeze

  attr_reader :initial_scope

  def filter_by_eq(scope:, field:, value:)
    scope.where(field => value)
  end

  def filter_by_like(scope:, field:, value:)
    scope.where(Sequel.like(field, "%#{value}%"))
  end
end
