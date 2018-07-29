# frozen_string_literal: true

module Api::V1::Coaches
  IndexSchema = Dry::Validation.Params(BaseSchema) do
    optional(:sort).filled

    optional(:filter).schema do
      optional(:fullname).filled(:str?)
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
