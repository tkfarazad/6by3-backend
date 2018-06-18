# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::DestroyAction do
  let!(:user) { create(:user) }
  let!(:current_user) { create(:user, :admin) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(id: user.id)
    end

    context 'when admin' do
      it 'grants access' do
        expect(call).to be_success
        expect(call.success.id).to eq(user.id)

        expect(call.success.deleted_at).not_to eq nil
      end
    end
  end
end
