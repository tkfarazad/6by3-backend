# frozen_string_literal: true

class ProcessVideoDataService
  include Dry::Transaction(container: ::Api::V1::Container)
  include ::TransactionContext[:original_video, :tmp_file_path]

  TMP_THUMBNAIL_FORMAT = "#{Rails.root}/tmp/uploads/%<filename>s.png"

  private_constant :TMP_THUMBNAIL_FORMAT

  tee :store_original_video
  tee :build_tmp_file_path
  tee :mkdir
  try :read_data, catch: Errno::ENOENT # https://github.com/streamio/streamio-ffmpeg/blob/master/lib/ffmpeg/movie.rb#L22
  map :build_updated_data
  try :update, catch: Sequel::InvalidOperation
  map :finalize

  private

  def store_original_video(video)
    context[:original_video] = video

    video.reset_state if video.processed?
    video.start_processing if video.may_start_processing?
  end

  def build_tmp_file_path
    context[:tmp_file_path] = format(
      TMP_THUMBNAIL_FORMAT,
      filename: SecureRandom.uuid
    )
  end

  def mkdir
    FileUtils.mkdir_p(File.dirname(tmp_file_path))
  end

  def read_data(video)
    FFMPEG::Movie.new(video.url)
  end

  def build_updated_data(video)
    {
      duration: video.duration,
      thumbnail: video.screenshot(tmp_file_path, seek_time: 0, quality: 1)
    }
  end

  def update(input)
    ::UpdateEntityOperation.new(original_video).call(input)
  end

  def finalize(video)
    File.delete(tmp_file_path) if File.exist?(tmp_file_path)

    video.end_processing

    video.save
  end
end
