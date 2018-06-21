# frozen_string_literal: true

class AvatarUploader < BasePhotoUploader
  def store_dir
    'avatars'
  end

  def extension_whitelist
    ::SixByThree::Constants::AVAILABLE_UPLOAD_AVATAR_EXTENSIONS
  end
end
