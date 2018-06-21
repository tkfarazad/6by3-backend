# frozen_string_literal: true

module Api::V1::User::Avatar
  class DestroyAction < ::Api::V1::BaseAction
    map :destroy

    def destroy
      current_user.remove_avatar!
      current_user.save
    end
  end
end
