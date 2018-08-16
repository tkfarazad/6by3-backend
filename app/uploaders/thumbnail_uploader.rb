# frozen_string_literal: true

class ThumbnailUploader < ::BasePhotoUploader
  def store_dir
    'thumbnails'
  end

  def size_range
    1..5.megabytes
  end
end
