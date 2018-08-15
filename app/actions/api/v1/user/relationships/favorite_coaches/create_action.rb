# frozen_string_literal: true

module Api::V1::User::Relationships::FavoriteCoaches
  class CreateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation

    private

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def create(params)
      ::UpdateEntityOperation.new(current_user).call(params)
    end
  end
end
