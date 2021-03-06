# frozen_string_literal: true

module Api::V1::Admin::Users
  DestroyBulkSchema = Dry::Validation.Schema(BaseSchema) do
    each do
      schema do
        required(:type).filled(eql?: 'users')
        required(:id).filled(:int?, gt?: 0)
      end
    end
  end
end
