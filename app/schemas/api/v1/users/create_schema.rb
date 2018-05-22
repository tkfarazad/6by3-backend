# frozen_string_literal: true

module Api::V1::Users
  CreateSchema = Dry::Validation.Form do
    configure do
      config.messages = :i18n

      def email?(value)
        !/.*@.*/.match(value).nil?
      end
    end

    required(:email).filled(:email?)
    required(:password).filled(min_size?: 6).confirmation
  end
end
