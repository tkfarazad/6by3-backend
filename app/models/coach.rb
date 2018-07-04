# frozen_string_literal: true

class Coach < Sequel::Model
  mount_uploader :avatar, ::AvatarUploader

  many_to_many :videos, join_table: :coaches_videos
end
