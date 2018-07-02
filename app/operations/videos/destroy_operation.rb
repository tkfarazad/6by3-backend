# frozen_string_literal: true

module Videos
  class DestroyOperation < BaseOperation
    def initialize(video)
      @video = video
    end

    def call
      hide_video
    end

    private

    attr_reader :video

    def hide_video
      video.update(deleted_at: Time.current)
    end
  end
end
