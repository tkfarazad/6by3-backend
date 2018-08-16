# frozen_string_literal: true

module Api::V1::User::Relationships::FavoriteCoaches
  IndexSchema = Dry::Validation.Params(BaseSchema) do
    optional(:page).schema do
      required(:number).filled(:int?, gt?: 0)
      required(:size).filled(:int?, gt?: 0)
    end
  end
end
