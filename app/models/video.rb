# frozen_string_literal: true

class Video < Sequel::Model
  mount_uploader :content, ::VideoUploader

  one_to_many :coaches_videos
  many_to_many :coaches, join_table: :coaches_videos
end
