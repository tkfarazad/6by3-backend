# frozen_string_literal: true

module Videos
  class UpdateOperation < BaseOperation
    def initialize(video)
      @video = video
    end

    def call(input)
      update_video(input)
    end

    private

    attr_reader :video

    def update_video(params)
      video.update(params)
    end
  end
end
