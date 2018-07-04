# frozen_string_literal: true

module Api::V1::Admin::Videos
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:name).filled(:str?)
    required(:description).filled(:str?)
    required(:content).filled(:video?)
  end
end
