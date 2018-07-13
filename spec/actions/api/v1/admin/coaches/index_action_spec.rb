# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Coaches::IndexAction do
  let!(:coach1) { create(:coach) }
  let!(:coach2) { create(:coach) }
  let!(:current_user) { create(:user, :admin) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    context 'no params' do
      let(:input) { {} }

      it 'returns all coaches' do
        expect(subject).to be_success
        expect(subject.success[0]).to match_array [coach1, coach2]
      end
    end

    context 'with filters' do
      let(:input) { {filter: {fullname: coach1.fullname}} }

      it 'returns all coaches with given fullname' do
        expect(subject).to be_success
        expect(subject.success[0]).to match_array [coach1]
      end
    end

    context 'with sorting' do
      let(:input) { {sort: '-created_at'} }

      it 'returns all coaches sorted' do
        expect(subject).to be_success
        expect(subject.success[0]).to eq [coach2, coach1]
      end
    end
  end
end
