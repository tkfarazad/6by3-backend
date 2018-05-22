# frozen_string_literal: true

module Api::V1
  class UserSerializer < Api::V1::BaseSerializer
    type 'users'

    attributes :email
  end
end
