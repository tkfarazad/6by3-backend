# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::CreateSchema do
  describe 'attributes' do
    def schema(**options)
      described_class.call(options)
    end

    describe 'first name' do
      def first_name_schema(first_name)
        schema(
          password: '123456',
          password_confirmation: '123456',
          email: FFaker::Internet.email,
          last_name: FFaker::Name.last_name,
          first_name: first_name
        )
      end

      it 'returns success' do
        expect(first_name_schema(FFaker::Name.first_name)).to be_success
      end

      it 'returns failure' do
        result = first_name_schema('')

        expect(result).to be_failure
        expect(result.errors).to eq(first_name: ['must be filled'])
      end
    end

    describe 'last name' do
      def last_name_schema(last_name)
        schema(
          password: '123456',
          password_confirmation: '123456',
          email: FFaker::Internet.email,
          first_name: FFaker::Name.first_name,
          last_name: last_name
        )
      end

      it 'returns success' do
        expect(last_name_schema(FFaker::Name.last_name)).to be_success
      end

      it 'returns failure' do
        result = last_name_schema('')

        expect(result).to be_failure
        expect(result.errors).to eq(last_name: ['must be filled'])
      end
    end

    describe 'email' do
      def email_schema(email)
        schema(
          first_name: FFaker::Name.first_name,
          last_name: FFaker::Name.last_name,
          password: '123456',
          password_confirmation: '123456',
          email: email
        )
      end

      it 'returns success' do
        expect(email_schema(FFaker::Internet.email)).to be_success
      end

      it 'returns failure' do
        result = email_schema('email')

        expect(result).to be_failure
        expect(result.errors).to eq(email: ['email is invalid email'])
      end
    end

    describe 'password' do
      def password_schema(password, confirmation)
        schema(
          first_name: FFaker::Name.first_name,
          last_name: FFaker::Name.last_name,
          email: FFaker::Internet.email,
          password: password,
          password_confirmation: confirmation
        )
      end

      it 'returns success' do
        expect(password_schema('123456', '123456')).to be_success
      end

      it 'returns failure' do
        result = password_schema(nil, nil)

        expect(result).to be_failure
        expect(result.errors).to eq(
          password: ['must be filled']
        )
      end

      it 'returns failure' do
        result = password_schema('123', '123')

        expect(result).to be_failure
        expect(result.errors).to eq(
          password: ['size cannot be less than 6']
        )
      end

      it 'returns failure' do
        result = password_schema('123456', '234567')

        expect(result).to be_failure
        expect(result.errors).to eq(password_confirmation: ['must be equal to 123456'])
      end
    end
  end
end
