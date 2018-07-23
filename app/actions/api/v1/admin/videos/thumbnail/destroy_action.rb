# frozen_string_literal: true

module Api::V1::Admin::Videos::Thumbnail
  class DestroyAction < ::Api::V1::BaseAction
    step :authorize
    try :find, catch: Sequel::NoMatchingRow
    map :destroy

    private

    def find(input)
      ::Video.with_pk!(input.fetch(:video_id))
    end

    def destroy(video)
      ::DestroyUploadOperation.new(video).call(mounted_as: 'thumbnail')
    end
  end
end
