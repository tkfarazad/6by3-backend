# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::UpdateSchema do
  describe 'attributes' do
    describe 'first_name' do
      def schema(first_name)
        described_class.call(first_name: first_name)
      end

      it 'returns failure' do
        result = schema('')

        expect(result).to be_failure
        expect(result.errors).to eq(first_name: ['must be filled'])
      end

      it 'returns success' do
        expect(schema(FFaker::Name.name)).to be_success
      end
    end
  end
end
