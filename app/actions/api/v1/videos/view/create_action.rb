# frozen_string_literal: true

module Api::V1::Videos::View
  class CreateAction < ::Api::V1::BaseAction
    step :validate, with: 'params.validate'
    try :find, catch: Sequel::NoMatchingRow
    try :create, catch: Sequel::UniqueConstraintViolation

    private

    def find(input)
      ::Video.with_pk!(input.fetch(:video_id))
    end

    def create(video)
      ::Views::Videos::View.new.call(user: current_user, video: video)
    end
  end
end
