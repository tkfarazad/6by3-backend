# frozen_string_literal: true

RSpec.describe Api::V1::ConfirmEmail::CreateAction do
  let(:action) { described_class.new }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let!(:user) { create(:user, :unconfirmed) }
    let(:input) do
      jsonapi_params(
        attributes: {
          token: token
        }
      )
    end
    let(:token) { SecureRandom.hex }

    context 'when params are invalid' do
      let(:input) { {} }

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          token: ['is missing']
        )
      end
    end

    context 'when token does not match' do
      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(parameters: ["Confirmation token is invalid."])
      end
    end

    context 'when token matches' do
      let!(:user) { create(:user, :unconfirmed, email_confirmation_token: token) }

      around do |example|
        Timecop.freeze

        example.run

        Timecop.return
      end

      it 'marks email as confirmed' do
        expect { call }.to(
          change { user.reload.email_confirmed_at.to_i }.to(Time.current.to_i)
            .and(change { user.reload.email_confirmation_token }.to(nil))
            .and(have_enqueued_job(Customerio::IdentifyUserJob).with(user_id: user.id))
            .and(have_enqueued_job(Customerio::TrackJob).with(user_id: user.id, event: 'email-confirmed'))
        )
      end

      context 'when confirmation token expired' do
        let!(:user) do
          create(
            :user,
            :unconfirmed,
            email_confirmation_token: token,
            email_confirmation_requested_at: Time.current - 5.days
          )
        end

        it 'returns failure' do
          expect(call).to be_failure
          expect(call.failure).to eq(parameters: ["Confirmation token has been expired."])
        end
      end
    end
  end
end
