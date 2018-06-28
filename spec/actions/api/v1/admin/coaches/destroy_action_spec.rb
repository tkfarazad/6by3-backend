# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Coaches::DestroyAction do
  let!(:coach) { create(:coach) }
  let!(:current_user) { create(:user, :admin) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(id: coach.id)
    end

    context 'when admin' do
      it 'grants access' do
        expect(call).to be_success
        expect(call.success.id).to eq(coach.id)

        expect(call.success.deleted_at).not_to eq nil
      end
    end
  end
end
