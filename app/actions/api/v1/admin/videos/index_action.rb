# frozen_string_literal: true

module Api::V1::Admin::Videos
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:videos_scope]

    step :authorize
    step :validate, with: 'params.validate'
    tee :find_videos
    map :build_meta, with: 'meta.paginate'
    map :build_response

    private

    def find_videos(params)
      context[:videos_scope] = ::VideosFinder.new(
        initial_scope: Video.dataset
      ).call(filter: params[:filter], sort: params[:sort], paginate: params[:page])
    end

    def build_meta(params)
      super(videos_scope) if params[:page].present?
    end

    def build_response(meta)
      [videos_scope.all, meta]
    end
  end
end
