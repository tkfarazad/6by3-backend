# frozen_string_literal: true

module Api::V1::User::Avatar
  class DestroyAction < ::Api::V1::BaseAction
    map :destroy

    def destroy
      ::DestroyUploadOperation.new(current_user).call(mounted_as: 'avatar')
    end
  end
end
