# frozen_string_literal: true

module Api::V1::VideoCategories
  IndexSchema = Dry::Validation.Params(BaseSchema) do
    optional(:sort).filled(:str?)

    optional(:filter).schema do
      optional(:name).filled(:str?)
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
