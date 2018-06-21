# frozen_string_literal: true

RSpec.describe Api::V1::User::Tokens::CreateSchema do
  context 'when schema is empty' do
    it 'returns failure' do
      result = described_class.call({})

      expect(result).to be_failure
      expect(result.errors).to eq(email_or_token: ['must be filled'])
    end
  end

  context 'when email is passed' do
    it 'returns success' do
      result = described_class.call(email: 'email@example.com', password: '123456')

      expect(result).to be_success
    end

    context 'when password is missed' do
      it 'returns failure' do
        result = described_class.call(email: 'email@example.com')

        expect(result).to be_failure
        expect(result.errors).to eq(password: ['must be filled'])
      end
    end
  end

  context 'when token is passed' do
    it 'returns success' do
      result = described_class.call(token: SecureRandom.uuid)

      expect(result).to be_success
    end
  end

  context 'when email and token are passed' do
    it 'returns failure' do
      result = described_class.call(email: 'email', password: 'password', token: 'token')

      expect(result).to be_failure
      expect(result.errors).to eq(email_only: ['cannot be defined'], token_only: ['cannot be defined'])
    end
  end
end
