# frozen_string_literal: true

module Api::V1::Admin::Users
  IndexSchema = Dry::Validation.Params do
    optional(:sort).filled

    optional(:filter).schema do
      optional(:email).filled(:str?)
      optional(:fullname).filled(:str?)
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
