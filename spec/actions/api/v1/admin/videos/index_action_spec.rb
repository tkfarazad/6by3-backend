# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Videos::IndexAction do
  let!(:video1) { create(:video) }
  let!(:video2) { create(:video) }
  let!(:current_user) { create(:user, :admin) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    context 'no params' do
      let(:input) { {} }

      it 'returns all videos' do
        expect(subject).to be_success
        expect(subject.success[0]).to match_array [video1, video2]
      end
    end

    context 'with filters' do
      let(:input) { {filter: {name: video1.name}} }

      it 'returns all videos with given name' do
        expect(subject).to be_success
        expect(subject.success[0]).to match_array [video1]
      end
    end

    context 'with sorting' do
      let(:input) { {sort: '-created_at'} }

      it 'returns all videos sorted' do
        expect(subject).to be_success
        expect(subject.success[0]).to match_array [video2, video1]
      end
    end
  end
end
