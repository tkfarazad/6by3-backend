# frozen_string_literal: true

module Api::V1::Admin
  class UserPolicy < ::ApplicationPolicy
    def index?
      user.admin?
    end

    def update?
      index?
    end

    def destroy?
      index?
    end

    def create?
      index?
    end

    class Scope < Scope
      def resolve
        scope
      end
    end
  end
end
