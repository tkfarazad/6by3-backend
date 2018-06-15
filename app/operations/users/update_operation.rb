# frozen_string_literal: true

module Users
  class UpdateOperation < BaseOperation
    def initialize(user)
      @user = user
    end

    def call(input)
      update_user(input)
    end

    private

    attr_reader :user

    def update_user(params)
      user.update(params)
    end
  end
end
