# frozen_string_literal: true

module Api::V1::Admin::Coaches::Avatar
  class CreateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:coach]

    step :authorize
    tee :find, catch: Sequel::NoMatchingRow
    step :validate, with: 'params.validate'
    map :create

    private

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    def validate(input)
      super(input, resolve_schema)
    end

    def find(input)
      context[:coach] = ::Coach.with_pk!(input.fetch(:coach_id))
    end

    def create(input)
      ::Coaches::UpdateOperation.new(coach).call(input)
    end

    def can?
      resolve_policy.new(current_user).create?
    end
  end
end
