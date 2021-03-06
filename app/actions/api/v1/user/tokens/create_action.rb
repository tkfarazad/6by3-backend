# frozen_string_literal: true

module Api::V1::User::Tokens
  class CreateAction < ::Api::V1::BaseAction
    include ::TransactionContext[:request]

    AUTH_TOKEN_LIFETIME = 5.days

    private_constant :AUTH_TOKEN_LIFETIME

    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    step :find
    step :email_confirmed
    step :authenticate
    tee :locate_user
    map :generate_token

    private

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def find(input)
      user = find_user(input)

      if user.nil?
        Failure(:user_not_found)
      else
        Success(input.merge!(user: user))
      end
    end

    def email_confirmed(input)
      user = input.fetch(:user)

      if user.email_confirmed_at.present?
        Success(input)
      else
        Failure(:email_not_confirmed)
      end
    end

    def authenticate(input)
      user = input.fetch(:user)

      if authenticated?(user: user, token: input[:token], password: input[:password])
        Success(user)
      else
        Failure(:password_not_matched)
      end
    end

    def locate_user(user)
      return if user.city.present? || user.country.present?

      ::LocateUserJob.perform_later(user_id: user.id, ip_addr: request.remote_ip)
    end

    def generate_token(user)
      ::Knock::AuthToken.new(payload: {sub: user.id}).token
    end

    def authenticated?(user:, token:, password:)
      by_token?(user: user, token: token) || by_password?(user: user, password: password)
    end

    def by_token?(user:, token:)
      token.present? && !user.nil?
    end

    def by_password?(user:, password:)
      !user.authenticate(password).nil?
    end

    def find_user(input)
      if input.key?(:email)
        ::User.find(email: input.fetch(:email))
      elsif input.key?(:token)
        token      = input.fetch(:token)
        valid_till = Time.current - AUTH_TOKEN_LIFETIME
        auth_token = ::AuthToken.find(
          Sequel.lit('token = :token AND created_at > :valid_till', token: token, valid_till: valid_till)
        )

        auth_token&.user
      end
    end
  end
end
