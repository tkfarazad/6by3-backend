# frozen_string_literal: true

module Api::V1::Admin::Users
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:users_scope, :finder_params]

    step :authorize
    step :validate, with: 'params.validate'
    tee :build_finder_params, with: 'params.finder.build'
    tee :find_users
    map :build_meta, with: 'meta.paginate'
    map :build_response

    private

    def build_finder_params(params)
      context[:finder_params] = super(params)
    end

    def find_users
      context[:users_scope] = ::UsersFinder.new(initial_scope: User.dataset).call(**finder_params)
    end

    def build_meta(params)
      super(users_scope) if params[:page].present?
    end

    def build_response(meta)
      [users_scope.all, meta]
    end
  end
end
