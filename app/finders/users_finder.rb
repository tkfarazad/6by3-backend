# frozen_string_literal: true

class UsersFinder < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[email first_name last_name].freeze
  AVAILABLE_SORTING_KEYS = %w[
    email
    first_name
    last_name
    created_at
    plan_type
    -email
    -first_name
    -last_name
    -created_at
    -plan_type
  ].freeze
end
