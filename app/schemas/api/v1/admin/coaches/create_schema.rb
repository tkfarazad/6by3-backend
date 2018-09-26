# frozen_string_literal: true

module Api::V1::Admin::Coaches
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:fullname).filled(:str?)
    optional(:avatar).filled(:image?, size?: ::SixByThree::Constants::PHOTO_FILE_SIZE_RANGE)
    optional(:featured).filled(:bool?)
    optional(:personal_info).filled(:str?)
    optional(:certifications).each(:str?)

    optional(:social_links).schema do
      optional(:facebook).filled(:str?)
      optional(:twitter).filled(:str?)
      optional(:instagram).filled(:str?)
      optional(:linkedin).filled(:str?)
      optional(:website).filled(:str?)
    end
  end
end
