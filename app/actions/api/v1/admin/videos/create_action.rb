# frozen_string_literal: true

module Api::V1::Admin::Videos
  class CreateAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation

    private

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    def create(input)
      ::Video.create(input)
    end

    def can?
      resolve_policy.new(current_user).create?
    end
  end
end
