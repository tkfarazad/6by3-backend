# frozen_string_literal: true

module Api::V1::User
  class DestroyAction < ::Api::V1::BaseAction
    map :destroy

    def destroy(user)
      ::Users::DestroyOperation.new(user).call
    end
  end
end
