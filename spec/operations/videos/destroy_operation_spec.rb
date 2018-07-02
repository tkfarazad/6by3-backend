# frozen_string_literal: true

RSpec.describe Videos::DestroyOperation do
  let!(:video) { create(:video) }

  describe '#call' do
    subject { described_class.new(video).call }

    it 'video is softly deleted' do
      expect { subject }.not_to change(Video, :count).from(1)
      expect(video.deleted_at).not_to eq nil
    end
  end
end
