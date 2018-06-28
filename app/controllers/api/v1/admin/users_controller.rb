# frozen_string_literal: true

module Api::V1::Admin
  class UsersController < ::Api::V1::Admin::BaseController
    IMPLEMENT_METHODS = :ALL

    def create
      super do |m|
        m.failure(:create) do
          head 409
        end
      end
    end
  end
end
