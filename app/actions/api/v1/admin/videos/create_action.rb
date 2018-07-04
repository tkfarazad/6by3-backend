# frozen_string_literal: true

module Api::V1::Admin::Videos
  class CreateAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation

    private

    def authorize(input)
      resolve_policy.new(current_user).to_monad(input, &:create?)
    end

    def create(input)
      ::Video.create(input)
    end
  end
end
