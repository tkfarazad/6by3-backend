# frozen_string_literal: true

module Api::V1::Admin::Videos
  DestroyBulkSchema = Dry::Validation.Schema(BaseSchema) do
    each do
      schema do
        required(:type).filled(eql?: 'videos')
        required(:id).filled(:int?, gt?: 0)
      end
    end
  end
end
