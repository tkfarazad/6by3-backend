# frozen_string_literal: true

class BasePhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_whitelist
    ::SixByThree::Constants::AVAILABLE_UPLOAD_AVATAR_EXTENSIONS
  end

  def size_range
    1..2.megabytes
  end
end
