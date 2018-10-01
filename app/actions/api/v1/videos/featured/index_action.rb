# frozen_string_literal: true

module Api::V1::Videos::Featured
  class IndexAction < ::Api::V1::BaseAction
    map :find_videos
    map :build_response

    private

    def find_videos
      ::VideosFinder
        .new(initial_scope: Video.dataset)
        .call(
          filter: {featured: {eq: true}},
          exclude: {deleted_at: ::SixByThree::Constants::VALUE_PRESENT}
        )
    end

    def build_response(videos)
      [videos.all]
    end
  end
end
