# frozen_string_literal: true

module Api::V1::Admin::Videos
  IndexSchema = Dry::Validation.Params(BaseSchema) do
    optional(:sort).filled

    optional(:filter).schema do
      optional(:name).filled(:str?)
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
