# frozen_string_literal: true

module SixByThree
  module Constants
    AVAILABLE_UPLOAD_IMAGE_EXTENSIONS = %w[png].freeze
    AVAILABLE_UPLOAD_IMAGE_CONTENT_TYPES = %w[image/png].freeze

    AVAILABLE_UPLOAD_VIDEO_EXTENSIONS = %w[mp4 avi mov].freeze
    AVAILABLE_UPLOAD_VIDEO_CONTENT_TYPES = %w[video/mp4 video/x-msvideo video/quicktime video/avi].freeze

    VIDEO_FILE_SIZE_RANGE = 1..10.gigabytes

    VALUE_PRESENT = :VALUE_PRESENT

    PUSHER_CHANNELS = [/^private-users\.\d+$/].freeze
  end
end
