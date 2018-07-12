# frozen_string_literal: true

class Video < Sequel::Model
  # Plugins
  plugin :association_pks

  mount_uploader :content, ::VideoUploader

  many_to_many :coaches, join_table: :coaches_videos, delay_pks: :always
end
