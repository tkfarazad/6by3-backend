# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::ShowAction do
  let!(:user) { create(:user) }
  let!(:current_user) { create(:user, :admin) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    context 'no params' do
      let(:input) { {} }

      it 'returns all users' do
        expect(subject).to be_failure
        expect(subject.failure).to eq(id: ['is missing'])
      end
    end

    context 'with id' do
      let(:input) { {id: user.id} }

      it 'returns finded user' do
        expect(subject).to be_success
        expect(subject.success).to eq user
      end
    end
  end
end
