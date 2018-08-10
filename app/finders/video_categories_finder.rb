# frozen_string_literal: true

class VideoCategoriesFinder < BaseFinder
  include Sortable
  include Filterable
  include Paginatable

  AVAILABLE_FILTERING_KEYS = %i[name].freeze
  AVAILABLE_SORTING_KEYS = %w[created_at -created_at].freeze
end
