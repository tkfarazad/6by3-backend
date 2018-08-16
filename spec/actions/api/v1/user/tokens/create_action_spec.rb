# frozen_string_literal: true

RSpec.describe Api::V1::User::Tokens::CreateAction do
  let(:action) { described_class.new }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    context 'when params are invalid' do
      let(:input) { {} }

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          email_or_token: ['must be filled']
        )
      end
    end

    context 'when authenticate by email and password' do
      let(:input) do
        jsonapi_params(
          attributes: {
            email: email,
            password: password
          }
        )
      end
      let(:email) { FFaker::Internet.email }
      let(:password) { FFaker::Internet.password }

      context 'when user does not exist' do
        it 'return failure' do
          expect(call).to be_failure
          expect(call.failure).to eq(:user_not_found)
        end
      end

      context 'when user exists' do
        context 'when email unconfirmed' do
          let!(:user) { create(:user, :unconfirmed, email: email) }

          it 'returns failure' do
            expect(call).to be_failure
            expect(call.failure).to eq(:email_not_confirmed)
          end
        end

        context 'when password does not match' do
          let!(:user) { create(:user, :confirmed, email: email) }

          it 'returns failure' do
            expect(call).to be_failure
            expect(call.failure).to eq(:password_not_matched)
          end
        end

        context 'when password matches' do
          let!(:user) { create(:user, :confirmed, email: email, password: password, password_confirmation: password) }

          it 'returns success' do
            expect(call).to be_success
          end
        end
      end
    end

    context 'when authenticate by auth token' do
      let(:input) do
        jsonapi_params(
          attributes: {
            token: token
          }
        )
      end
      let(:token) { SecureRandom.uuid }

      context 'when user does not exist' do
        it 'return failure' do
          expect(call).to be_failure
          expect(call.failure).to eq(:user_not_found)
        end
      end

      context 'when user exists' do
        let!(:user) { create(:user, :confirmed) }
        let!(:auth_token) { create(:auth_token, token: token, user: user) }

        it 'returns success' do
          expect(call).to be_success
        end

        context 'when token has been expired' do
          let!(:auth_token) { create(:auth_token, token: token, created_at: Time.current - 7.days) }

          it 'returns failure' do
            expect(call).to be_failure
            expect(call.failure).to eq(:user_not_found)
          end
        end
      end
    end
  end
end
