# frozen_string_literal: true

class LocateUserJob < ApplicationJob
  def perform(user_id:, ip_addr:)
    user = User.with_pk!(user_id)

    ::LocateUserService.new.call(user, ip_addr)
  end
end
