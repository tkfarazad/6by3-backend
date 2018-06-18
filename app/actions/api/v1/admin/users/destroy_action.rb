# frozen_string_literal: true

module Api::V1::Admin::Users
  class DestroyAction < ::Api::V1::BaseAction
    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    map :destroy

    def find(input)
      ::User.with_pk!(input.fetch(:id))
    end

    def authorize(user)
      return Failure(:authorize) unless can?

      Success(user)
    end

    def destroy(user)
      ::Users::DestroyOperation.new(user).call
    end

    private

    def can?
      resolve_policy.new(current_user).destroy?
    end
  end
end
