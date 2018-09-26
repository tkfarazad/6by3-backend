# frozen_string_literal: true

class ThumbnailUploader < ::BasePhotoUploader
  def store_dir
    'thumbnails'
  end

  def size_range
    ::SixByThree::Constants::THUMBNAIL_FILE_SIZE_RANGE
  end
end
