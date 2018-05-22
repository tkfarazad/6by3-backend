# frozen_string_literal: true

module Api::V1::User::Tokens
  class CreateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    step :find
    step :authenticate
    map :generate_token

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def validate(input)
      super(input, resolve_schema)
    end

    def find(email:, password:)
      user = ::User.find(email: email)

      if user
        Success(user: user, password: password)
      else
        Failure(:user_not_found)
      end
    end

    def authenticate(user:, password:)
      if same_password?(user: user, password: password)
        Success(user)
      else
        Failure(:password_not_matched)
      end
    end

    def generate_token(user)
      ::Knock::AuthToken.new(payload: {sub: user.id}).token
    end

    private

    def same_password?(user:, password:)
      !user.authenticate(password).nil?
    end
  end
end
