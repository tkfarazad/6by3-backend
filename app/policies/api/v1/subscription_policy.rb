# frozen_string_literal: true

module Api::V1
  class SubscriptionPolicy < ApplicationPolicy
    def cancel?
      record.user_id == user.id
    end
  end
end
