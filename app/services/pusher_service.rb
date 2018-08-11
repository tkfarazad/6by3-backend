# frozen_string_literal: true

class PusherService
  class << self
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
