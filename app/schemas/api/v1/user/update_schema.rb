# frozen_string_literal: true

module Api::V1::User
  UpdateSchema = Dry::Validation.Form do
    optional(:fullname).filled(:str?)
  end
end
