# frozen_string_literal: true

class ProcessVideoDataJob < ApplicationJob
  def perform(video_id:)
    video = Video.with_pk!(video_id)

    ProcessVideoDataService.new.call(video)
  end
end
