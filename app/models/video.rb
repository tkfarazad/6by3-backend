# frozen_string_literal: true

class Video < Sequel::Model
  include ::Viewable::Viewable

  # Plugins
  plugin :association_pks

  mount_uploader :content, ::VideoUploader
  mount_uploader :thumbnail, ::ThumbnailUploader

  one_to_many :views, class: VideoView
  many_to_many :coaches, join_table: :coaches_videos, delay_pks: :always
end
