# frozen_string_literal: true

module MetaBuilder
  class Paginate < BaseOperation
    def call(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        page_count: collection.page_count,
        record_count: collection.pagination_record_count
      }
    end
  end
end
