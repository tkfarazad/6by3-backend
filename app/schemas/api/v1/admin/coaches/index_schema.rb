# frozen_string_literal: true

module Api::V1::Admin::Coaches
  IndexSchema = Dry::Validation.Params(BaseSchema) do
    optional(:sort).filled(:str?)

    optional(:filter).schema do
      optional(:fullname).filled(:str?)
      optional(:category).filled { each(:int?) }
      optional(:featured).schema do
        required(:eq).filled(:bool?)
      end
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
