# frozen_string_literal: true

module RSpec
  module Support
    class Pusher
      def trigger(channels, event, data)
        @events ||= []

        @events << {
          channels: Array(channels),
          event: event,
          data: data.to_json
        }
      end

      def events
        return [] if @events.nil?

        @events.map do |event|
          {
            channels: event[:channels],
            event: event[:event],
            data: JSON.parse(event[:data])
          }
        end
      end
    end
  end
end
