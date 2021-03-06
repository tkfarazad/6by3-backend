# frozen_string_literal: true

module Api::V1::Admin::Coaches
  class CreateAction < ::Api::V1::BaseAction
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation

    private

    def create(input)
      ::Coach.create(input)
    end
  end
end
