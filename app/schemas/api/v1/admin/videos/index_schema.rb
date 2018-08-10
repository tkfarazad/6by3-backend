# frozen_string_literal: true

module Api::V1::Admin::Videos
  IndexSchema = Dry::Validation.Params(BaseSchema) do
    optional(:sort).filled(:str?)

    optional(:filter).schema do
      optional(:name).filled(:str?)
      optional(:duration).schema do
        required(:from).filled(:int?)
        required(:to).filled(:int?)
      end
      optional(:coach).filled { each(:int?) }
      optional(:category).filled { each(:int?) }
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
