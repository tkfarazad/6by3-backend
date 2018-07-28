# frozen_string_literal: true

class VideosFinder < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[name duration].freeze
  AVAILABLE_SORTING_KEYS = %w[created_at -created_at views_count -views_count].freeze

  # List of filter params which should use custom filters instead of specified by program
  CUSTOM_FILTERS = {
    duration: 'filter_by_range'
  }.freeze

  private

  def filter_by_range(scope:, field:, value:)
    range = value[:from]..value[:to]

    scope.where(field => range)
  end
end
