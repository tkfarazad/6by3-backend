# frozen_string_literal: true

module SixByThree
  module Constants
    AVAILABLE_UPLOAD_IMAGE_EXTENSIONS = %w[png jpg jpeg].freeze
    AVAILABLE_UPLOAD_IMAGE_CONTENT_TYPES = %w[image/png image/jpeg].freeze

    AVAILABLE_UPLOAD_VIDEO_EXTENSIONS = %w[mp4 avi mov mpeg].freeze
    AVAILABLE_UPLOAD_VIDEO_CONTENT_TYPES = %w[video/mp4 video/x-msvideo video/quicktime video/avi video/mpeg].freeze

    VIDEO_FILE_SIZE_RANGE = 1..14.gigabytes
    PHOTO_FILE_SIZE_RANGE = 1..2.megabytes
    THUMBNAIL_FILE_SIZE_RANGE = 1..5.megabytes

    VALUE_PRESENT = :VALUE_PRESENT

    PUSHER_CHANNELS = [/^private-users\.\d+$/].freeze
  end
end
