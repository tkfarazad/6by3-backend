# frozen_string_literal: true

module Api::V1::ConfirmEmail
  class CreateAction < ::Api::V1::BaseAction
    CONFIRMATION_TOKEN_LIFETIME = 3.days

    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    map :find_user
    step :check_processable
    map :confirm

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def validate(input)
      super(input, resolve_schema)
    end

    def find_user(input)
      ::User.find(email_confirmation_token: input.fetch(:token))
    end

    def check_processable(user)
      if user.nil?
        Failure(error(I18n.t('errors.confirm_email.create.token_invalid')))
      elsif token_expired?(user)
        Failure(error(I18n.t('errors.confirm_email.create.token_expired')))
      else
        Success(user)
      end
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
