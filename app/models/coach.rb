# frozen_string_literal: true

class Coach < Sequel::Model
  mount_uploader :avatar, AvatarUploader
end
