# frozen_string_literal: true

module Api::V1::Users
  class CreateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation

    def validate(input)
      super(input, resolve_schema)
    end

    def create(input)
      ::User.create(input)
    end
  end
end
