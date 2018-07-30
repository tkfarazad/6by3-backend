# frozen_string_literal: true

module Paginatable
  private

  def apply_pagination(scope, page)
    build_pagination_records(scope, page)
  end

  def build_pagination_records(scope, page)
    scope.paginate(page[:number], page[:size])
  end
end
