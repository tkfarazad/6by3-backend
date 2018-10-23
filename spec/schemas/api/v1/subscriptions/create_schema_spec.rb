# frozen_string_literal: true

RSpec.describe Api::V1::Subscriptions::CreateSchema do
  describe 'attributes' do
    subject { described_class.call(params) }

    describe 'coupon' do
      context 'when coupon not passed' do
        let(:params) { {plan_id: rand(100)} }

        it 'returns success' do
          expect(subject).to be_success
        end
      end

      context 'when coupon with whitespaces' do
        let(:params) { {plan_id: rand(100), coupon: " coupon \n"} }

        it 'returns success' do
          expect(subject).to be_success
          expect(subject[:coupon]).to eq('coupon')
        end
      end
    end
  end
end
