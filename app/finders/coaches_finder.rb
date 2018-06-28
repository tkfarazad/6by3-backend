# frozen_string_literal: true

class CoachesFinder < BaseFinder
  include Sortable
  include Filterable
  include Paginatable

  AVAILABLE_FILTERING_KEYS = %i[fullname].freeze
  AVAILABLE_SORTING_KEYS = %w[created_at -created_at].freeze
end
