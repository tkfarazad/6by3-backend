# frozen_string_literal: true

module Api::V1::Videos
  IndexSchema = Dry::Validation.Params(BaseSchema) do
    optional(:sort).filled

    optional(:filter).schema do
      optional(:name).filled(:str?)
      optional(:duration).schema do
        required(:from).filled(:int?)
        required(:to).filled(:int?)
      end
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
