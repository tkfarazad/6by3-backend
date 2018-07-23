# frozen_string_literal: true

RSpec.describe DestroyUploadOperation do
  let!(:user) { create(:user) }
  let!(:video) { create(:video) }

  describe '#call' do
    it 'record upload is deleted' do
      described_class.new(user).call(mounted_as: 'avatar')

      expect(user.avatar.present?).to be_falsey
    end
  end

  describe 'works with different mounts' do
    it 'record upload is deleted' do
      described_class.new(video).call(mounted_as: 'thumbnail')

      expect(video.thumbnail.present?).to be_falsey
    end
  end
end
