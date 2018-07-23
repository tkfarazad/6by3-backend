# frozen_string_literal: true

class ThumbnailUploader < ::BasePhotoUploader
  def store_dir
    'thumbnails'
  end
end
