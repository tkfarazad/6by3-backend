# frozen_string_literal: true

module Customerio
  class IdentifyUsersJob < ApplicationJob
    queue_as :customerio

    def perform
      User.select(:id).order(:id).paged_each do |user|
        Customerio::IdentifyUserJob.perform_later(user_id: user.id)
      end
    end
  end
end
