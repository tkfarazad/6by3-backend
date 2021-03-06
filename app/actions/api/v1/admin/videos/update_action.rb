# frozen_string_literal: true

module Api::V1::Admin::Videos
  class UpdateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:original_video, :updated_url]

    try :find, catch: Sequel::NoMatchingRow
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :update, catch: Sequel::InvalidOperation
    tee :enqueue_process_video

    private

    def find(input)
      context[:updated_url] = input[:url]
      context[:original_video] = ::Video.with_pk!(input.fetch(:id))

      input
    end

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def update(input)
      ::UpdateEntityOperation.new(original_video).call(input)
    end

    def enqueue_process_video(video)
      ::ProcessVideoDataJob.perform_later(video_id: video.id) if updated_url
    end
  end
end
