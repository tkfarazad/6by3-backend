# frozen_string_literal: true

RSpec.describe Api::V1::User::DestroyAction do
  let!(:current_user) { create(:user) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:other_user_call) do
      action.call(create(:user))
    end

    subject(:self_call) do
      action.call(current_user)
    end

    context 'when self' do
      it 'grants access' do
        expect(self_call).to be_success
        expect(self_call.success).to eq(current_user)

        expect(self_call.success.deleted_at).not_to eq nil
      end
    end
  end
end
