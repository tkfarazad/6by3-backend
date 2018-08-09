# frozen_string_literal: true

class CoachesFinder < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[fullname featured].freeze
  AVAILABLE_SORTING_KEYS = %w[created_at -created_at].freeze
end
