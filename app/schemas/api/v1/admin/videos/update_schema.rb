# frozen_string_literal: true

module Api::V1::Admin::Videos
  UpdateSchema = Dry::Validation.Params(BaseSchema) do
    optional(:name).filled(:str?)
    optional(:description).filled(:str?)
    optional(:content).filled(:video?)
    optional(:coach_pks).each(:int?)
  end
end