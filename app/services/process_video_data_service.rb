# frozen_string_literal: true

class ProcessVideoDataService
  include Dry::Transaction(container: ::Api::V1::Container)
  include ::TransactionContext[:original_video]

  tee :store_original_video
  try :read_data, catch: Errno::ENOENT # https://github.com/streamio/streamio-ffmpeg/blob/master/lib/ffmpeg/movie.rb#L22
  map :build_updated_data
  try :update, catch: Sequel::InvalidOperation

  private

  def store_original_video(video)
    context[:original_video] = video
  end

  def read_data(video)
    FFMPEG::Movie.new(video.url)
  end

  def build_updated_data(video)
    {
      duration: video.duration,
      thumbnail: video.screenshot('thumbnail.png', seek_time: 0, quality: 1)
    }
  end

  def update(input)
    ::UpdateEntityOperation.new(original_video).call(input)
  end
end
