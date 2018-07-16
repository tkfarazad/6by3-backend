# frozen_string_literal: true

class BaseVideoUploader < BaseUploader
  include CarrierWave::Video

  def extension_whitelist
    ::SixByThree::Constants::AVAILABLE_UPLOAD_VIDEO_EXTENSIONS
  end

  def size_range
    1..2.gigabytes
  end
end
