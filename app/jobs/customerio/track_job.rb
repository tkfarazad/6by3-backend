# frozen_string_literal: true

module Customerio
  class TrackJob < ApplicationJob
    queue_as :customerio

    def perform(user_id:, event:, **attributes)
      Customerio::TrackService.new.call(user_id: user_id, event: event, **attributes)
    end
  end
end
