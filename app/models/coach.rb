# frozen_string_literal: true

class Coach < Sequel::Model
  # Plugins
  plugin :association_pks

  mount_uploader :avatar, ::AvatarUploader

  many_to_many :videos, join_table: :coaches_videos, delay_pks: :always

  many_through_many :categories, [
    %i[coaches_videos coach_id video_id],
    [:videos, :id, Sequel[:videos][:category_id]]
  ], class_name: 'VideoCategory'
end
