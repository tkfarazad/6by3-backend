# frozen_string_literal: true

module Api::V1::Admin
  class UserPolicy < ::ApplicationPolicy
    def index?
      user.admin?
    end

    alias show? index?
    alias update? index?
    alias create? index?
    alias destroy? index?

    class Scope < Scope
      def resolve
        scope
      end
    end
  end
end
