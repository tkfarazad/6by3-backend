# frozen_string_literal: true

module Api::V1::Admin::Videos
  class DestroyAction < ::Api::V1::BaseAction
    step :authorize
    try :find, catch: Sequel::NoMatchingRow
    map :destroy

    private

    def find(input)
      ::Video.with_pk!(input.fetch(:id))
    end

    def destroy(video)
      ::SoftDestroyEntityOperation.new(video).call
    end
  end
end
