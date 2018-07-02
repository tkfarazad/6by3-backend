# frozen_string_literal: true

module Api::V1::Admin::Videos
  class DestroyAction < ::Api::V1::BaseAction
    step :authorize
    try :find, catch: Sequel::NoMatchingRow
    map :destroy

    private

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    def find(input)
      ::Video.with_pk!(input.fetch(:id))
    end

    def destroy(video)
      ::Videos::DestroyOperation.new(video).call
    end

    def can?
      resolve_policy.new(current_user).destroy?
    end
  end
end
