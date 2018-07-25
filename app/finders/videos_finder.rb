# frozen_string_literal: true

class VideosFinder < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[name].freeze
  AVAILABLE_SORTING_KEYS = %w[created_at -created_at views_count -views_count].freeze
end
