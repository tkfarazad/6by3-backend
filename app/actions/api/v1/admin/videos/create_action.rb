# frozen_string_literal: true

module Api::V1::Admin::Videos
  class CreateAction < ::Api::V1::BaseAction
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation
    tee :enqueue_process_video

    private

    def create(input)
      ::Video.create(input)
    end

    def enqueue_process_video(video)
      ::ProcessVideoDataJob.perform_later(video.id)
    end
  end
end
