# frozen_string_literal: true

module Api::V1::Admin::Users
  class ShowAction < ::Api::V1::BaseAction
    step :authorize
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow

    private

    def find(input)
      ::User.with_pk!(input.fetch(:id))
    end
  end
end
