# frozen_string_literal: true

module Api::V1::Admin::Coaches
  IndexSchema = Dry::Validation.Params do
    optional(:filter).schema do
      optional(:fullname).filled(:str?)
    end

    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
