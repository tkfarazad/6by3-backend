# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::ResetPassword::CreateAction do
  let!(:user) { create(:user, :admin) }
  let(:action) { described_class.new(context: {current_user: user}) }

  let!(:reset_password_user) { create(:user) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    context 'when user with this id exists' do
      let(:input) { {user_id: reset_password_user.id} }

      it 'sends instructions' do
        expect(SendResetPasswordInstructionsJob).to receive(:perform_later)

        call
      end
    end

    context 'when user with this id does not exist' do
      let(:input) { {user_id: 0} }

      it 'does not send instructions' do
        expect(SendResetPasswordInstructionsJob).to_not receive(:perform_later)

        call
      end
    end
  end
end
