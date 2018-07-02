# frozen_string_literal: true

class VideoUploader < BaseVideoUploader
  def store_dir
    'videos'
  end
end
