# frozen_string_literal: true

module Api::V1::Videos::Viewed
  class IndexAction < ::Api::V1::BaseAction
    include ::TransactionContext[:videos_scope]

    step :validate, with: 'params.validate'
    tee :find_videos
    map :build_response

    private

    def find_videos
      context[:videos_scope] = ::Video
                               .dataset
                               .select_all(:videos)
                               .join(:video_views, video_id: :id)
                               .where(Sequel[:video_views][:user_id] => current_user.id)
                               .order(Sequel.desc(:created_at))
    end

    def build_response
      [videos_scope.all]
    end
  end
end
