# frozen_string_literal: true

module Api::V1::User
  class AvatarController < ::Api::V1::ApplicationController
    include ::ImageUploadActions
  end
end
