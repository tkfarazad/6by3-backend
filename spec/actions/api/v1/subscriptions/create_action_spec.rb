# frozen_string_literal: true

RSpec.describe Api::V1::Subscriptions::CreateAction, :stripe do
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

    let(:coupon) { SecureRandom.hex }
    let(:plan) { create(:stripe_plan, :applicable) }
    let(:plan_id) { plan.id.to_s }
    let(:plan_type) { 'plans' }

    let(:create_operation) { instance_double('SC::Billing::Stripe::Subscriptions::CreateOperation') }

    before do
      allow(SC::Billing::Stripe::Subscriptions::CreateOperation).to receive(:new).and_return(create_operation)
    end

    context 'when subscription was created successfully' do
      before do
        subscription = create(:stripe_subscription)
        allow(create_operation).to receive(:call).and_return(Dry::Monads::Result::Success.new(subscription))
      end

      it 'returns success' do
        expect(call).to be_success
      end
    end

    context 'when plan not applicable' do
      let(:plan) { create(:stripe_plan, applicable: false) }

      it 'returns failure' do
        expect(call).to be_failure
      end
    end

    context 'when user already has active subscription' do
      before do
        create(:stripe_subscription, :active, user: current_user)
      end

      it 'returns failure' do
        expect(call).to be_failure
      end
    end

    context 'when user already has trialing subscription' do
      before do
        create(:stripe_subscription, :trialing, user: current_user)
      end

      it 'returns failure' do
        expect(call).to be_failure
      end
    end

    context 'when user already has canceled subscription' do
      before do
        create(:stripe_subscription, :canceled, user: current_user)

        subscription = create(:stripe_subscription)
        allow(create_operation).to receive(:call).and_return(Dry::Monads::Result::Success.new(subscription))
      end

      it 'returns failure' do
        expect(call).to be_success
      end
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
        error = Stripe::InvalidRequestError.new('coupon is invalid', {})
        allow(create_operation).to receive(:call).and_return(Dry::Monads::Result::Failure.new(error))
      end

      it 'returns failure' do
        expect(call).to be_failure
      end
    end

    context 'when card is invalid' do
      before do
        error = Stripe::CardError.new('Some error', nil, 402)
        allow(create_operation).to receive(:call).and_return(Dry::Monads::Result::Failure.new(error))
      end

      it 'returns failure' do
        expect(call).to be_failure
      end
    end
  end
end
