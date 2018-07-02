# frozen_string_literal: true

RSpec.describe Videos::UpdateOperation do
  let(:initial_name) { FFaker::Video.name }
  let!(:video) { create(:video, name: initial_name) }

  describe '#call' do
    subject { described_class.new(video).call(input) }

    context 'params valid' do
      let(:new_name) { FFaker::Video.name }
      let(:input) { {name: new_name} }

      it 'video is updated' do
        expect { subject }.to change(video, :name).from(initial_name).to(new_name)
        expect(video.updated_at).not_to eq(video.created_at)
      end
    end
  end
end
