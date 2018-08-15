# frozen_string_literal: true

module Api::V1
  class PaymentSourcePolicy < ApplicationPolicy
    def destroy?
      record.user_id == user.id
    end

    alias make_default? destroy?
  end
end
