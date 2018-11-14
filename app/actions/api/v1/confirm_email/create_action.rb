# frozen_string_literal: true

module Api::V1::ConfirmEmail
  class CreateAction < ::Api::V1::BaseAction
    CONFIRMATION_TOKEN_LIFETIME = 1.day

    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    map :find_user
    step :check_not_found
    step :check_processable
    map :confirm

    private

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def find_user(input)
      ::User.find(email_confirmation_token: input.fetch(:token))
    end

    def check_not_found(user)
      return Failure(error(I18n.t('errors.confirm_email.create.token_invalid'))) if user.nil?

      Success(user)
    end

    def check_processable(user)
      return Failure(error(I18n.t('errors.confirm_email.create.token_expired'))) if token_expired?(user)

      Success(user)
    end

    def confirm(user)
      user.update(
        email_confirmed_at: Time.current,
        email_confirmation_token: nil
      )
    end

    def token_expired?(user)
      user.email_confirmation_requested_at < (Time.current - CONFIRMATION_TOKEN_LIFETIME)
    end
  end
end
