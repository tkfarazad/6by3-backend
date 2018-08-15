# frozen_string_literal: true

module Api::V1::Videos::View
  class DestroyAction < ::Api::V1::BaseAction
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow
    map :destroy

    private

    def find(input)
      ::Video.with_pk!(input.fetch(:video_id))
    end

    def destroy(video)
      ::Views::Videos::Unview.new.call(user: current_user, video: video)
    end
  end
end
