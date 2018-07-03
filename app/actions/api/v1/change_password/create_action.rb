# frozen_string_literal: true

module Api::V1::ChangePassword
  class CreateAction < ::Api::V1::BaseAction
    PASSWORD_RESET_TOKEN_LIFETIME = 3.days

    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    map :find_user
    step :check_processable
    map :change

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def find_user(input)
      input.merge!(
        user: ::User.find(reset_password_token: input.fetch(:token))
      )
    end

    def check_processable(input)
      user = input.fetch(:user)

      if user.nil?
        Failure(error(I18n.t('errors.change_password.create.token_invalid')))
      elsif token_expired?(user)
        Failure(error(I18n.t('errors.change_password.create.token_expired')))
      else
        Success(input)
      end
    end

    def change(user:, password:, **_args)
      user
        .set(
          password: password,
          reset_password_token: nil,
          reset_password_requested_at: nil
        )
        .save
    end

    private

    def token_expired?(user)
      user.reset_password_requested_at < (Time.current - PASSWORD_RESET_TOKEN_LIFETIME)
    end
  end
end
