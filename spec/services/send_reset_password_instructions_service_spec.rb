# frozen_string_literal: true

RSpec.describe SendResetPasswordInstructionsService do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(user)
    end

    let(:user) { create(:user) }

    it 'sends letter' do
      expect(UserMailer).to(
        receive_message_chain(
          with: hash_including(:user_id),
          reset_password: no_args,
          deliver_later: no_args
        )
      )

      expect { call }.to(
        change { user.reload.reset_password_token }
          .and(change { user.reload.reset_password_requested_at })
      )
    end
  end
end
