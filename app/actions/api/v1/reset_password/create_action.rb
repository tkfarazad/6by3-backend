# frozen_string_literal: true

module Api::V1::ResetPassword
  class CreateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    map :find_user
    tee :reset_password

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def find_user(input)
      ::User.find(email: input.fetch(:email))
    end

    def reset_password(user)
      return if user.nil?

      SendResetPasswordInstructionsJob.perform_later(user_id: user.id)
    end
  end
end
