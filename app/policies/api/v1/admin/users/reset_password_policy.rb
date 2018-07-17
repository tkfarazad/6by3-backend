# frozen_string_literal: true

module Api::V1::Admin::Users
  class ResetPasswordPolicy < ::ApplicationPolicy
    def create?
      user.admin?
    end

    class Scope < Scope
      def resolve
        scope
      end
    end
  end
end
