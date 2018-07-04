# frozen_string_literal: true

module Api::V1::Admin::Users
  class DestroyAction < ::Api::V1::BaseAction
    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    map :destroy

    private

    def find(input)
      ::User.with_pk!(input.fetch(:id))
    end

    def authorize(user)
      resolve_policy.new(current_user).to_monad(user, &:destroy?)
    end

    def destroy(user)
      ::Users::DestroyOperation.new(user).call
    end
  end
end
