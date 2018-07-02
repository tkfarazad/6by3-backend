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

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    def validate(input)
      super(input, resolve_schema)
    end

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

    def can?
      resolve_policy.new(current_user).index?
    end
  end
end
