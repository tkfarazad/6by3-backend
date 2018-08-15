# frozen_string_literal: true

module Views::Videos
  class Unview < BaseOperation
    def call(user:, video:)
      ::VideoView.where(user: user, video: video).destroy if video.viewed_by?(user.id)
    end
  end
end
