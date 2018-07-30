# frozen_string_literal: true

module Api::V1::Coaches
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:coaches_scope]

    step :validate, with: 'params.validate'
    map :build_finder_params, with: 'params.finder.build'
    tee :find_coaches
    map :build_meta, with: 'meta.paginate'
    map :build_response

    private

    def find_coaches(params)
      context[:coaches_scope] = ::CoachesFinder.new(initial_scope: Coach.dataset).call(params)
    end

    def build_meta(params)
      super(coaches_scope) if params[:page].present?
    end

    def build_response(meta)
      [coaches_scope.all, meta]
    end
  end
end
