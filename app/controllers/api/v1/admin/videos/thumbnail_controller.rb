# frozen_string_literal: true

module Api::V1::Admin::Videos
  class ThumbnailController < ::Api::V1::ApplicationController
    include ::ImageUploadActions
  end
end
