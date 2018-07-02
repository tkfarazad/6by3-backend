# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Videos::ShowAction do
  let!(:video) { create(:video) }
  let!(:current_user) { create(:user, :admin) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    context 'no params' do
      let(:input) { {} }

      it 'returns all videos' do
        expect(subject).to be_failure
        expect(subject.failure).to eq(id: ['is missing'])
      end
    end

    context 'with id' do
      let(:input) { {id: video.id} }

      it 'returns finded video' do
        expect(subject).to be_success
        expect(subject.success).to eq video
      end
    end
  end
end
