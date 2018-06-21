# frozen_string_literal: true

class User < Sequel::Model
  plugin :secure_password, include_validations: false

  mount_uploader :avatar, AvatarUploader

  def self.from_token_payload(payload)
    find(id: payload.fetch('sub'))
  end
end
