# frozen_string_literal: true

class VideoUploader < ::BaseVideoUploader
  def store_dir
    'videos'
  end

  process :save_video_data

  def save_video_data
    video = FFMPEG::Movie.new(file.file)

    model.duration = video.duration.round
  end
end
