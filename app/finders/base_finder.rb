# frozen_string_literal: true

class BaseFinder
  def initialize(initial_scope:)
    @initial_scope = initial_scope
  end

  def call(filter: false, sort: false, paginate: false)
    scope = initial_scope
    scope = apply_filters(scope, filter) if filter
    scope = apply_sorting(scope, sort) if sort
    scope = apply_pagination(scope, paginate) if paginate
    scope
  end

  private

  attr_reader :initial_scope

  def filter_by(scope:, field:, value:)
    scope.where(field => value)
  end
end
