# frozen_string_literal: true

namespace :six_by_three do
  task set_duration_for_videos: :environment do
    Video.where(duration: nil).each do |video|
      video.update(
        duration: FFMPEG::Movie.new(video.content.file.file).duration
      )
    end
  end
end
