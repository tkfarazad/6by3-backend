# frozen_string_literal: true

module Api::V1::Admin::Coaches
  class DestroyAction < ::Api::V1::BaseAction
    step :authorize
    try :find, catch: Sequel::NoMatchingRow
    map :destroy

    def authorize(coach)
      return Failure(:authorize) unless can?

      Success(coach)
    end

    def find(input)
      ::Coach.with_pk!(input.fetch(:id))
    end

    def destroy(coach)
      ::Coaches::DestroyOperation.new(coach).call
    end

    private

    def can?
      resolve_policy.new(current_user).destroy?
    end
  end
end
