# frozen_string_literal: true

class User < Sequel::Model
  plugin :secure_password, include_validations: false

  mount_uploader :avatar, AvatarUploader

  one_to_many :video_views

  def self.from_token_payload(payload)
    find(id: payload.fetch('sub'))
  end
end
