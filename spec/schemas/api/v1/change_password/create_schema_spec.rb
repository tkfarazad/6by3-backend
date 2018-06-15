# frozen_string_literal: true

RSpec.describe Api::V1::ChangePassword::CreateSchema do
  describe 'attributes' do
    describe 'token' do
      def schema(token)
        described_class.call(password: '123456', password_confirmation: '123456', token: token)
      end

      it { expect(schema(SecureRandom.hex)).to be_success }

      it 'returns failure', :aggregate_failures do
        result = schema(nil)

        expect(result).to be_failure
        expect(result.errors).to eq(token: ['must be filled'])
      end
    end

    describe 'password' do
      def schema(password, confirmation)
        described_class.call(token: SecureRandom.hex, password: password, password_confirmation: confirmation)
      end

      it { expect(schema('123456', '123456')).to be_success }

      it 'returns failure', :aggregate_failures do
        result = schema(nil, nil)

        expect(result).to be_failure
        expect(result.errors).to eq(
          password: ['must be filled']
        )
      end

      it 'returns failure', :aggregate_failures do
        result = schema('123', '123')

        expect(result).to be_failure
        expect(result.errors).to eq(
          password: ['size cannot be less than 6']
        )
      end

      it 'returns failure', :aggregate_failures do
        result = schema('123456', '234567')

        expect(result).to be_failure
        expect(result.errors).to eq(password_confirmation: ['must be equal to 123456'])
      end
    end
  end
end
