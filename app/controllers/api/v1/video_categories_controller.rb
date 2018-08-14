# frozen_string_literal: true

module Api::V1
  class VideoCategoriesController < ::Api::V1::ApplicationController
    skip_before_action :authenticate_user, only: %i[index show]

    include ::ShowableConcern
  end
end
