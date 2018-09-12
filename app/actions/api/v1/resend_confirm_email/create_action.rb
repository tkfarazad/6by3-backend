# frozen_string_literal: true

module Api::V1::ResendConfirmEmail
  class CreateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    map :find
    step :check_not_found
    tee :send_confirmation_letter

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def find(input)
      ::User.find(email: input.fetch(:email))
    end

    def check_not_found(user)
      return Failure(error(I18n.t('errors.confirm_email.create.token_invalid'))) if user.nil?

      Success(user)
    end

    def send_confirmation_letter(user)
      SendConfirmationLetterJob.perform_later(user_id: user.id)
    end
  end
end
