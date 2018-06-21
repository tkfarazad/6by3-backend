# frozen_string_literal: true

module Api::V1
  class UserSerializer < Api::V1::BaseSerializer
    type 'users'

    attributes :email,
               :avatar

    attribute :admin, if: -> { current_user_or_admin? }

    def current_user?
      @current_user&.id == @object.id
    end

    def current_user_or_admin?
      current_user? || @current_user&.admin?
    end
  end
end
