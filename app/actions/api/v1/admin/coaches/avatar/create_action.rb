# frozen_string_literal: true

module Api::V1::Admin::Coaches::Avatar
  class CreateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:coach]

    step :authorize
    tee :find, catch: Sequel::NoMatchingRow
    step :validate, with: 'params.validate'
    map :create

    private

    def find(input)
      context[:coach] = ::Coach.with_pk!(input.fetch(:coach_id))
    end

    def create(input)
      ::Coaches::UpdateOperation.new(coach).call(input)
    end
  end
end
