# frozen_string_literal: true

module Api::V1::Admin::Users
  IndexSchema = Dry::Validation.Params(BaseSchema) do
    optional(:sort).filled(:str?)

    optional(:filter).schema do
      optional(:email).filled(:str?)
      optional(:first_name).filled(:str?)
      optional(:last_name).filled(:str?)
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
