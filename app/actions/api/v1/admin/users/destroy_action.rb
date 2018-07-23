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

    def destroy(user)
      ::SoftDestroyEntityOperation.new(user).call
    end
  end
end
