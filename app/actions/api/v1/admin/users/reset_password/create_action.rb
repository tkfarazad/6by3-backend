# frozen_string_literal: true

module Api::V1::Admin::Users::ResetPassword
  class CreateAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow
    tee :reset_password

    private

    def find(input)
      ::User.with_pk!(input.fetch(:user_id))
    end

    def reset_password(user)
      SendResetPasswordInstructionsJob.perform_later(user_id: user.id)
    end
  end
end
