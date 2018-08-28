# frozen_string_literal: true

class BaseFinder
  def initialize(initial_scope:)
    @initial_scope = initial_scope
  end

  def call(filter: false, sort: false, page: false, exclude: false)
    scope = initial_scope
    scope = apply_exclusion(scope, exclude) if exclude
    scope = apply_filters(scope, filter) if filter
    scope = apply_sorting(scope, sort) if sort
    scope = apply_pagination(scope, page) if page
    scope
  end

  private

  CUSTOM_FILTERS = {}.freeze

  attr_reader :initial_scope

  def filter_by_eq(scope:, field:, value:)
    scope.where(field => value)
  end

  def filter_by_ilike(scope:, field:, value:)
    scope.where(Sequel.ilike(field, "%#{value}%"))
  end
end
