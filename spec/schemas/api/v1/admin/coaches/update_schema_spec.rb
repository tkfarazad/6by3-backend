# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Coaches::UpdateSchema do
  describe 'attributes' do
    describe 'fullname' do
      def schema(fullname)
        described_class.call(fullname: fullname)
      end

      it 'returns failure' do
        result = schema('')

        expect(result).to be_failure
        expect(result.errors).to eq(fullname: ['must be filled'])
      end

      it 'returns success' do
        expect(schema(FFaker::Name.name)).to be_success
      end
    end

    describe 'personal_info' do
      def schema(personal_info)
        described_class.call(personal_info: personal_info)
      end

      it 'returns failure' do
        result = schema('')

        expect(result).to be_failure
        expect(result.errors).to eq(personal_info: ['must be filled'])
      end

      it 'returns success' do
        expect(schema(FFaker::Book.description)).to be_success
      end
    end
  end
end
