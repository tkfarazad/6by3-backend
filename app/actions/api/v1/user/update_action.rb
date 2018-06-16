# frozen_string_literal: true

module Api::V1::User
  class UpdateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :update, catch: Sequel::InvalidOperation

    def validate(input)
      super(input, resolve_schema)
    end

    def update(input)
      ::Users::UpdateOperation.new(current_user).call(input)
    end
  end
end