# frozen_string_literal: true

module Api::V1::Admin::Users
  class IndexAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    map :find_users

    def validate(input)
      super(input, resolve_schema)
    end

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    private

    def can?
      resolve_policy.new(current_user).index?
    end

    def find_users(params)
      ::UsersFinder.new(
        initial_scope: User.dataset
      ).call(filter: params[:filter], sort: params[:sort], paginate: params[:paginate]).all
    end
  end
end
