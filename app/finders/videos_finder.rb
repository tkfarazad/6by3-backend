# frozen_string_literal: true

class VideosFinder < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[name duration coach category].freeze
  AVAILABLE_SORTING_KEYS = %w[created_at -created_at views_count -views_count].freeze

  # List of filter params which should use custom filters instead of specified by program
  CUSTOM_FILTERS = {
    duration: 'filter_by_range',
    coach: 'filter_by_coach_fullname',
    category: 'filter_by_category_name'
  }.freeze

  private

  def filter_by_range(scope:, field:, value:)
    range = value[:from]..value[:to]

    scope.where(field => range)
  end

  def filter_by_coach_fullname(scope:, field:, value:) # rubocop:disable Lint/UnusedMethodArgument
    scope
      .select(Sequel.lit('videos.*'))
      .join(:coaches_videos, video_id: :id)
      .join(:coaches, id: :coach_id)
      .where(Sequel[:coaches][:fullname] => value.split(','))
  end

  def filter_by_category_name(scope:, field:, value:) # rubocop:disable Lint/UnusedMethodArgument
    scope
      .select(Sequel.lit('videos.*'))
      .join(:video_categories, id: :category_id)
      .where(Sequel[:video_categories][:name] => value.split(','))
  end
end
