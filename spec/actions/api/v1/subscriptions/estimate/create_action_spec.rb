# frozen_string_literal: true

RSpec.describe Api::V1::Subscriptions::Estimate::CreateAction, :stripe do
  let(:stripe_customer) { Stripe::Customer.create }
  let(:current_user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(
        attributes: {
          coupon: coupon
        },
        relationships: {
          plan: {
            data: {
              id: plan_id,
              type: plan_type
            }
          }
        }
      )
    end

    let(:coupon) { stripe_helper.generate_card_token }
    let(:plan) { create(:stripe_plan) }
    let(:plan_id) { plan.id.to_s }
    let(:plan_type) { 'plans' }

    before do
      allow(::Stripe::Invoice).to receive(:upcoming).with(any_args).and_return(Stripe::Invoice.create)
    end

    it 'returns success' do
      expect(call).to be_success
    end

    context 'when params are invalid' do
      let(:input) { jsonapi_params }

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(plan_id: ['is missing'])
      end
    end

    context 'when coupon is invalid' do
      let(:coupon) { 'coupon' }

      before do
        allow(::Stripe::Invoice).to(
          receive(:upcoming)
            .with(any_args)
            .and_raise(Stripe::InvalidRequestError.new('coupon is invalid', {}))
        )
      end

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to be_a(Stripe::InvalidRequestError)
      end
    end

    context 'when card is invalid' do
      before do
        allow(::Stripe::Invoice).to(
          receive(:upcoming)
            .with(any_args)
            .and_raise(Stripe::CardError.new('Some error', nil, 402))
        )
      end

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to be_a(Stripe::CardError)
      end
    end
  end
end
