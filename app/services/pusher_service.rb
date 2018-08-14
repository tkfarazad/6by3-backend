# frozen_string_literal: true

class PusherService
  class << self
    def authenticate_channel(channel_name:, socket_id:)
      ::Api::V1::Container['pusher'].authenticate(channel_name, socket_id)
    end

    def trigger(type:, **params)
      case type
      when :video_processed
        video_processed(params)
      end
    end

    private

    def video_processed(**params)
      ::Api::V1::Container['pusher'].trigger("videos.#{params.fetch(:id)}", 'processing', status: :finished)
    end
  end
end
