# frozen_string_literal: true

class Video < Sequel::Model
  include AASM
  include ::Viewable::Viewable

  # Plugins
  plugin :association_pks

  mount_uploader :thumbnail, ::ThumbnailUploader

  many_to_one :category, class: VideoCategory
  one_to_many :views, class: VideoView
  many_to_many :coaches, join_table: :coaches_videos, delay_pks: :always

  aasm column: 'state' do
    state :can_be_processed, initial: true
    state :processing
    state :processed

    event :start_processing do
      transitions from: :can_be_processed, to: :processing
    end

    event :end_processing, after: :notify_processed do
      transitions from: :processing, to: :processed
    end
  end

  def notify_processed
    ::PusherService.trigger(type: :video_processed, id: id) if processed?
  end
end
