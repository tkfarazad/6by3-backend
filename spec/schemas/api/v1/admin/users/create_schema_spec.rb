# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::CreateSchema do
  describe 'attributes' do
    describe 'email' do
      def schema(email)
        described_class.call(password: '123456', password_confirmation: '123456', email: email)
      end

      it { expect(schema('email@example.com')).to be_success }
      it 'returns failure' do
        result = schema('email')

        expect(result).to be_failure
        expect(result.errors).to eq(email: ['email is invalid email'])
      end
    end

    describe 'password' do
      def schema(password, confirmation)
        described_class.call(email: 'email@example.com', password: password, password_confirmation: confirmation)
      end

      it { expect(schema('123456', '123456')).to be_success }

      it 'returns failure' do
        result = schema(nil, nil)

        expect(result).to be_failure
        expect(result.errors).to eq(
          password: ['must be filled']
        )
      end

      it 'returns failure' do
        result = schema('123', '123')

        expect(result).to be_failure
        expect(result.errors).to eq(
          password: ['size cannot be less than 6']
        )
      end

      it 'returns failure' do
        result = schema('123456', '234567')

        expect(result).to be_failure
        expect(result.errors).to eq(password_confirmation: ['must be equal to 123456'])
      end
    end
  end
end
