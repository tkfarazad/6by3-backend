# frozen_string_literal: true

module Api::V1::Admin::Videos::Thumbnail
  class CreateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:video]

    step :authorize
    tee :find, catch: Sequel::NoMatchingRow
    step :validate, with: 'params.validate'
    map :create

    private

    def find(input)
      context[:video] = ::Video.with_pk!(input.fetch(:video_id))
    end

    def create(input)
      ::UpdateEntityOperation.new(video).call(input)
    end
  end
end
