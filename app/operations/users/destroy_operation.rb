# frozen_string_literal: true

module Users
  class DestroyOperation < BaseOperation
    def initialize(user)
      @user = user
    end

    def call
      hide_user
    end

    private

    attr_reader :user

    def hide_user
      user.update(deleted_at: Time.current)
    end
  end
end
