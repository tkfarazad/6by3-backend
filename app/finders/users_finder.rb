# frozen_string_literal: true

class UsersFinder < BaseFinder
  include Sortable
  include Filterable
  include Paginatable

  AVAILABLE_FILTERING_KEYS = %i[email fullname].freeze
  AVAILABLE_SORTING_KEYS = %w[created_at -created_at].freeze
end
