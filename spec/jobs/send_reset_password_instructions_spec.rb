# frozen_string_literal: true

RSpec.describe SendResetPasswordInstructionsJob do
  describe '.perform' do
    let(:user) { create(:user) }

    subject(:perform) do
      described_class.perform_now(user_id: user.id)
    end

    it 'calls service' do
      expect_any_instance_of(SendResetPasswordInstructionsService).to receive(:call).with(user)

      perform
    end
  end
end
