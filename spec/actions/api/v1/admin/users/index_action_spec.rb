# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::IndexAction do
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
        expect(subject).to be_success
        expect(subject.success[0]).to match_array [user, current_user]
      end
    end

    context 'with filters' do
      let(:input) { {filter: {first_name: user.first_name, last_name: user.last_name}} }

      it 'returns all users with given first and last names' do
        expect(subject).to be_success
        expect(subject.success[0]).to match_array [user]
      end
    end

    context 'with sorting' do
      let(:input) { {sort: '-created_at'} }

      it 'returns all users sorted' do
        expect(subject).to be_success
        expect(subject.success[0]).to eq [current_user, user]
      end
    end
  end
end
