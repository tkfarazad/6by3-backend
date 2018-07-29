# frozen_string_literal: true

module Api::V1::Videos
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:videos_scope, :finder_params]

    step :validate, with: 'params.validate'
    tee :build_finder_params, with: 'params.finder.build'
    tee :find_videos
    map :build_meta, with: 'meta.paginate'
    map :build_response

    private

    def build_finder_params(params)
      context[:finder_params] = super(params)
    end

    def find_videos
      context[:videos_scope] = ::VideosFinder.new(initial_scope: Video.dataset).call(**finder_params)
    end

    def build_meta(params)
      super(videos_scope) if params[:page].present?
    end

    def build_response(meta)
      [videos_scope.all, meta]
    end
  end
end
