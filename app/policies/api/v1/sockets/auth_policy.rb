# frozen_string_literal: true

module Api::V1::Sockets
  class AuthPolicy < ApplicationPolicy
    def create?
      Integer(record.fetch(:channel_name)[/\d+/]) == user.id
    end

    class Scope < Scope
      def resolve
        scope
      end
    end
  end
end
