# frozen_string_literal: true

module Api::V1::User::Tokens
  CreateSchema = Dry::Validation.Params do
    optional(:email).filled.when(:filled?) do
      value(:password).filled?
    end
    optional(:password).filled
    optional(:token).filled

    rule(email_or_token: %i[email token]) do |email, token|
      email.filled? | token.filled?
    end

    rule(email_only: %i[email token]) do |email, token|
      email.filled? > token.none?
    end

    rule(token_only: %i[email token]) do |email, token|
      token.filled? > email.none?
    end
  end
end
