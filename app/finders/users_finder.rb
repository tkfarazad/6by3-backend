# frozen_string_literal: true

class UsersFinder < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[email fullname].freeze
  AVAILABLE_SORTING_KEYS = %w[email -email fullname -fullname created_at -created_at plan_type -plan_type].freeze
end
