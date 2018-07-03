# frozen_string_literal: true

module Api::V1::Admin::Users
  class CreateAction < ::Api::V1::BaseAction
    step :authorize
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    def create(input)
      ::User.create(input)
    end

    private

    def can?
      resolve_policy.new(current_user).create?
    end
  end
end
