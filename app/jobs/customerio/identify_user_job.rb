# frozen_string_literal: true

module Customerio
  class IdentifyUserJob < ApplicationJob
    queue_as :customerio

    def perform(user_id:)
      user = User.with_pk!(user_id)

      Customerio::IdentifyUserService.new.call(user: user)
    end
  end
end
