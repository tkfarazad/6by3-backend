# frozen_string_literal: true

RSpec.describe Api::V1::ContactUsEmail::CreateSchema do
  describe 'attributes' do
    def schema(**options)
      described_class.call(options.reverse_merge(
                             name: FFaker::Name.name,
                             email: FFaker::Internet.email,
                             message: FFaker::Book.description
      ))
    end

    describe 'name' do
      it 'returns failure' do
        result = schema(name: nil)

        expect(result).to be_failure
        expect(result.errors).to eq(name: ['must be filled'])
      end
    end

    describe 'email' do
      it 'returns failure' do
        result = schema(email: nil)

        expect(result).to be_failure
        expect(result.errors).to eq(email: ['must be filled'])
      end
    end

    describe 'message' do
      it 'returns failure' do
        result = schema(message: nil)

        expect(result).to be_failure
        expect(result.errors).to eq(message: ['must be filled'])
      end
    end

    describe 'when valid' do
      it 'returns success' do
        result = schema

        expect(result).to be_success
      end
    end
  end
end
