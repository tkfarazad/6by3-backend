# frozen_string_literal: true

RSpec.describe SendConfirmationLetterService do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(user)
    end

    let(:user) { create(:user) }

    it 'sends letter' do
      expect(UserMailer).to(
        receive_message_chain(
          with: hash_including(:user_id, :auth_token_id),
          confirmation: no_args,
          deliver_later: no_args
        )
      )

      expect { call }.to(
        change { user.reload.email_confirmation_token }
          .and(change { user.reload.email_confirmation_requested_at })
          .and(change(AuthToken, :count).by(1))
      )
    end
  end
end
