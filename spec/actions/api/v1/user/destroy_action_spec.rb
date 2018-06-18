# frozen_string_literal: true

RSpec.describe Api::V1::User::DestroyAction do
  let!(:user) { create(:user) }

  let(:action) { described_class.new(context: {current_user: user}) }

  describe '#call' do
    subject(:call) do
      action.call(user)
    end

    context 'when self' do
      it 'grants access' do
        expect(call).to be_success
        expect(call.success).to eq(user)

        expect(call.success.deleted_at).not_to eq nil
      end
    end
  end
end
