# frozen_string_literal: true

module Api::V1::Admin::Coaches
  class ShowAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow

    def authorize(input)
      return Failure(:authorize) unless can?

      Success(input)
    end

    def validate(input)
      super(input, resolve_schema)
    end

    def find(input)
      ::Coach.with_pk!(input.fetch(:id))
    end

    private

    def can?
      resolve_policy.new(current_user).show?
    end
  end
end
