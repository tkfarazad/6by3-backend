# frozen_string_literal: true

class AvatarUploader < ::BasePhotoUploader
  def store_dir
    'avatars'
  end
end
