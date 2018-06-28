# frozen_string_literal: true

module Api::V1
  module SerializerHelper
    private

    def current_user?
      @current_user&.id == @object.id
    end

    def current_user_is_admin?
      @current_user&.admin?
    end

    def current_user_or_admin?
      current_user? || current_user_is_admin?
    end
  end
end
