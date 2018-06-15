# frozen_string_literal: true

RSpec.describe Api::V1::User::UpdateSchema do
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
  end
end
