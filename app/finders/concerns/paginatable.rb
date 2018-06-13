# frozen_string_literal: true

module Paginatable
  private

  def apply_pagination(scope, paginate)
    build_pagination_records(scope, paginate)
  end

  def build_pagination_records(scope, paginate)
    scope.paginate(paginate[:number], paginate[:size])
  end
end
