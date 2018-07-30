# frozen_string_literal: true

module Api::V1::Admin::Users
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:users_scope]

    step :authorize
    step :validate, with: 'params.validate'
    map :build_finder_params, with: 'params.finder.build'
    tee :find_users
    map :build_meta, with: 'meta.paginate'
    map :build_response

    private

    def find_users(params)
      context[:users_scope] = ::UsersFinder.new(initial_scope: User.dataset).call(params)
    end

    def build_meta(params)
      super(users_scope) if params[:page].present?
    end

    def build_response(meta)
      [users_scope.all, meta]
    end
  end
end
