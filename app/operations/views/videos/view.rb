# frozen_string_literal: true

module Views
  module Videos
    class View < BaseOperation
      def call(user:, video:)
        ::VideoView.create(user: user, video: video) unless video.viewed_by?(user.id)
      end
    end
  end
end
