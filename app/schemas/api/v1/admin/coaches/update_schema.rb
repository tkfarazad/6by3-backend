# frozen_string_literal: true

module Api::V1::Admin::Coaches
  UpdateSchema = Dry::Validation.Params(BaseSchema) do
    optional(:avatar).filled(:image?)
    optional(:fullname).filled(:str?)
    optional(:personal_info).filled(:str?)
    optional(:video_pks).each(:int?)
    optional(:certifications).each(:str?)
  end
end
