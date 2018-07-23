# frozen_string_literal: true

module Api::V1::User
  class UpdateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :update, catch: Sequel::InvalidOperation

    def update(input)
      ::UpdateEntityOperation.new(current_user).call(input)
    end
  end
end
