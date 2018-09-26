# frozen_string_literal: true

module Api::V1::Admin::Coaches::Avatar
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:avatar).filled(:image?, size?: ::SixByThree::Constants::PHOTO_FILE_SIZE_RANGE)
  end
end
