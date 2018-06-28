# frozen_string_literal: true

module Api::V1::User::Avatar
  class DestroyAction < ::Api::V1::BaseAction
    map :destroy

    def destroy
      ::Avatar::DestroyOperation.new(current_user).call
    end
  end
end
