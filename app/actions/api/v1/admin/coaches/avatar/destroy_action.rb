# frozen_string_literal: true

module Api::V1::Admin::Coaches::Avatar
  class DestroyAction < ::Api::V1::BaseAction
    step :authorize
    try :find, catch: Sequel::NoMatchingRow
    map :destroy

    private

    def find(input)
      ::Coach.with_pk!(input.fetch(:coach_id))
    end

    def destroy(coach)
      ::Avatar::DestroyOperation.new(coach).call
    end
  end
end
