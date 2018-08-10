# frozen_string_literal: true

module Api::V1::VideoCategories
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:categories_scope]

    step :validate, with: 'params.validate'
    tee :find_categories
    map :build_meta, with: 'meta.paginate'
    map :build_response

    private

    def find_categories(params)
      context[:categories_scope] = ::VideoCategoriesFinder.new(initial_scope: VideoCategory.dataset).call(params)
    end

    def build_meta(params)
      super(categories_scope) if params[:page].present?
    end

    def build_response(meta)
      [categories_scope.all, meta]
    end
  end
end
