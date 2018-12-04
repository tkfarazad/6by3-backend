# frozen_string_literal: true

module Customerio
  class TrackService
    include Import['customerio.client']

    def call(user_id:, event:, **attributes)
      client.track(user_id, event, attributes)
    end
  end
end
