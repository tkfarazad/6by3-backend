# frozen_string_literal: true

module Api::V1::Admin::Coaches
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:coaches_scope]

    step :authorize
    step :validate, with: 'params.validate'
    tee :find_coaches
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

    def find_coaches(params)
      context[:coaches_scope] = ::CoachesFinder.new(
        initial_scope: Coach.dataset
      ).call(filter: params[:filter], sort: params[:sort], paginate: params[:page])
    end

    def build_meta(params)
      super(coaches_scope) if params[:page].present?
    end

    def build_response(meta)
      [coaches_scope.all, meta]
    end

    def can?
      resolve_policy.new(current_user).index?
    end
  end
end
