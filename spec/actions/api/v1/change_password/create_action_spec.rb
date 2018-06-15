# frozen_string_literal: true

RSpec.describe Api::V1::ChangePassword::CreateAction do
  let(:action) { described_class.new }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let!(:user) { create(:user, :reset_password_requested) }
    let(:input) do
      jsonapi_params(
        attributes: {
          token: token,
          password: password,
          passwordConfirmation: password_confirmation
        }
      )
    end
    let(:token) { SecureRandom.hex }
    let(:password) { FFaker::Internet.password }
    let(:password_confirmation) { password }

    context 'when params are invalid' do
      let(:input) { {} }

      it 'returns failure', :aggregate_failures do
        expect(call).to be_failure
        expect(call.failure).to eq(
          token: ['is missing'],
          password: ['is missing', 'size cannot be less than 6']
        )
      end
    end

    context 'when token does not match' do
      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(parameters: ["Reset password token is invalid."])
      end
    end

    context 'when token matches' do
      let!(:user) { create(:user, :reset_password_requested, reset_password_token: token) }

      it 'changes password', :aggregate_failures do
        expect { call }.to(
          change { user.reload.password_digest }
          .and(change { user.reload.reset_password_token }.to(nil))
          .and(change { user.reload.reset_password_requested_at }.to(nil))
        )
      end

      context 'when reset password token expired' do
        let!(:user) do
          create(
            :user,
            :reset_password_requested,
            reset_password_token: token,
            reset_password_requested_at: Time.current - 5.days
          )
        end

        it 'returns failure' do
          expect(call).to be_failure
          expect(call.failure).to eq(parameters: ["Reset password token has been expired."])
        end
      end
    end
  end
end
