# frozen_string_literal: true

class Video < Sequel::Model
  mount_uploader :content, ::VideoUploader

  many_to_many :coaches, join_table: :coaches_videos
end
