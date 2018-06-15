# frozen_string_literal: true

RSpec.describe Api::V1::User::Tokens::CreateAction do
  let(:action) { described_class.new }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:email) { FFaker::Internet.email }
    let(:password) { FFaker::Internet.password }

    let(:input) do
      jsonapi_params(attributes: {email: email, password: password})
    end

    context 'when params are invalid' do
      let(:input) { {} }

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          email: ['is missing'],
          password: ['is missing']
        )
      end
    end

    context 'when user does not exist' do
      it 'return failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(:user_not_found)
      end
    end

    context 'when user exists' do
      let!(:user) { create(:user, email: email) }

      context 'when password does not match' do
        it 'returns failure' do
          expect(call).to be_failure
          expect(call.failure).to eq(:password_not_matched)
        end
      end

      context 'when password matches' do
        let!(:user) { create(:user, email: email, password: password, password_confirmation: password) }

        it 'returns success' do
          expect(call).to be_success
        end
      end
    end
  end
end
