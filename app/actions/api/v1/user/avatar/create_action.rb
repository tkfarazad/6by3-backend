# frozen_string_literal: true

module Api::V1::User::Avatar
  class CreateAction < ::Api::V1::BaseAction
    step :validate, with: 'params.validate'
    map :create

    def validate(input)
      super(input, resolve_schema)
    end

    def create(input)
      ::Users::UpdateOperation.new(current_user).call(input)
    end
  end
end
