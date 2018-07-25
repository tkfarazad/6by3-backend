# frozen_string_literal: true

RSpec.describe Viewable::Viewable do
  let!(:user) { create(:user) }
  let!(:video) { create(:video) }

  context 'viewed_by?' do
    it 'return bool whether user has watched video' do
      expect(video.viewed_by?(user.id)).to be_falsey

      create(:video_view, user: user, video: video)

      expect(video.viewed_by?(user.id)).to be_truthy
    end
  end
end
