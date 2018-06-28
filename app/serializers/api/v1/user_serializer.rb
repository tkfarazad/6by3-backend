# frozen_string_literal: true

module Api::V1
  class UserSerializer < Api::V1::BaseSerializer
    type 'users'

    attributes :email,
               :avatar,
               :fullname

    attribute :admin, if: -> { current_user_or_admin? }
    attribute :deleted_at, if: -> { current_user_or_admin? }
  end
end
