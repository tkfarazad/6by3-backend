# frozen_string_literal: true

module Api::V1::Admin::Videos
  class SignPolicy < ApplicationPolicy
    def show?
      user.admin?
    end

    class Scope < Scope
      def resolve
        scope
      end
    end
  end
end
