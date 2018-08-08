# frozen_string_literal: true

class ProcessVideoDataService < ApplicationJob
  def call(video)
    duration(video)
  end

  private

  def duration(video)
    duration = FFMPEG::Movie.new(video.url)

    video.update(duration: duration.duration)
  end
end
