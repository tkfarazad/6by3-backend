# frozen_string_literal: true

module Api::V1::Admin::Users
  class CreateAction < ::Api::V1::BaseAction
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation

    private

    def create(input)
      ::User.create(input.merge(created_in: User::USERS_CREATED_IN_ADMIN_TYPE))
    end
  end
end
