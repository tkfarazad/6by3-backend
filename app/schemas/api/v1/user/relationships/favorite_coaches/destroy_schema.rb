# frozen_string_literal: true

module Api::V1::User::Relationships::FavoriteCoaches
  DestroySchema = Dry::Validation.Params(BaseSchema) do
    required(:favorite_coach_pks).each(:int?)
  end
end
