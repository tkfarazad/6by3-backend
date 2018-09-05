# frozen_string_literal: true

class CoachesFinder < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[fullname featured category].freeze
  AVAILABLE_SORTING_KEYS = %w[fullname -fullname created_at -created_at].freeze

  # List of filter params which should use custom filters instead of specified by program
  CUSTOM_FILTERS = {
    category: 'filter_by_video_category_name'
  }.freeze

  private

  def filter_by_video_category_name(scope:, field:, value:) # rubocop:disable Lint/UnusedMethodArgument
    scope
      .select_all(:coaches)
      .join(:coaches_videos, coach_id: :id)
      .join(:videos, id: :video_id)
      .where(Sequel[:videos][:category_id] => value)
  end
end
