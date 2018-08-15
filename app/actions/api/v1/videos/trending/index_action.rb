# frozen_string_literal: true

module Api::V1::Videos::Trending
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:videos_scope]

    step :validate, with: 'params.validate'
    map :build_params
    tee :find_coaches
    map :build_meta, with: 'meta.paginate'
    map :build_response

    private

    def build_params(params)
      params = params.merge(filter: {trending: true})
      params = params.merge(page: {number: 1, size: 6}) unless params[:page].present?

      params
    end

    def find_coaches(params)
      context[:videos_scope] = ::VideosFinder.new(initial_scope: Video.dataset).call(params)
    end

    def build_meta(params)
      super(videos_scope) if params[:page].present?
    end

    def build_response(meta)
      [videos_scope.all, meta]
    end
  end
end
