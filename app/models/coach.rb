# frozen_string_literal: true

class Coach < Sequel::Model
  mount_uploader :avatar, ::AvatarUploader

  one_to_many :coaches_videos
  many_to_many :videos, join_table: :coaches_videos
end
