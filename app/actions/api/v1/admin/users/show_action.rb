# frozen_string_literal: true

module Api::V1::Admin::Users
  class ShowAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow

    private

    def authorize(input)
      resolve_policy.new(current_user).to_monad(input, &:show?)
    end

    def find(input)
      ::User.with_pk!(input.fetch(:id))
    end
  end
end
