# frozen_string_literal: true

RSpec.describe Api::V1::ResetPassword::CreateAction do
  let(:action) { described_class.new }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(
        attributes: {
          email: email
        }
      )
    end
    let(:email) { FFaker::Internet.email }

    context 'when params are invalid' do
      let(:input) do
        jsonapi_params(
          attributes: {}
        )
      end

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          email: ['is missing', ' is invalid email']
        )
      end
    end

    context 'when user with this email exists' do
      before do
        create(:user, email: email)
      end

      it 'sends instructions' do
        expect(SendResetPasswordInstructionsJob).to receive(:perform_later)

        call
      end
    end

    context 'when user with this email does not exist' do
      it 'does not send instructions' do
        expect(SendResetPasswordInstructionsJob).to_not receive(:perform_later)

        call
      end
    end
  end
end
