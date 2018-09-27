# frozen_string_literal: true

module Api::V1::User
  UpdateSchema = Dry::Validation.Params(BaseSchema) do
    optional(:first_name).filled(:str?)
    optional(:last_name).filled(:str?)
    optional(:avatar).filled(:image?, size?: ::SixByThree::Constants::PHOTO_FILE_SIZE_RANGE)
    optional(:privacy_policy_accepted).filled(:bool?)
  end
end
