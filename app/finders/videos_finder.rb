# frozen_string_literal: true

class VideosFinder < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[name featured duration coach category trending].freeze
  AVAILABLE_SORTING_KEYS = %w[created_at -created_at views_count -views_count].freeze

  # List of filter params which should use custom filters instead of specified by program
  CUSTOM_FILTERS = {
    duration: 'filter_by_range',
    coach: 'filter_by_coach_fullname',
    category: 'filter_by_category_name',
    trending: 'filter_by_trending'
  }.freeze

  private

  def filter_by_range(scope:, field:, value:)
    range = value[:from]..value[:to]

    scope.where(field => range)
  end

  def filter_by_coach_fullname(scope:, field:, value:) # rubocop:disable Lint/UnusedMethodArgument
    scope
      .select_all(:videos)
      .join(:coaches_videos, video_id: :id)
      .where(Sequel[:coaches_videos][:coach_id] => value)
  end

  def filter_by_category_name(scope:, field:, value:) # rubocop:disable Lint/UnusedMethodArgument
    scope
      .where(Sequel[:videos][:category_id] => value)
  end

  def filter_by_trending(scope:, field:, value:) # rubocop:disable Lint/UnusedMethodArgument
    scope
      .select_all(:videos)
      .join(:video_views, video_id: :id)
      .where(Sequel[:video_views][:created_at] => Time.now.beginning_of_week..Time.now.end_of_week)
      .distinct
  end
end
