# frozen_string_literal: true

RSpec.describe ActualizeUserPlanTypeService do
  describe '#call' do
    subject(:call) do
      described_class.new.call(subscription)
    end

    context 'when user has trialing subscription status' do
      let(:user) { create(:user) }
      let(:subscription) { create(:stripe_subscription, :trialing, user: user) }

      it 'actualizes plan type' do
        expect { call }.to change { user.reload.plan_type }.to('trial')
      end
    end

    context 'when user has free plan' do
      let(:user) { create(:user) }
      let(:plan) { create(:stripe_plan, amount: 0) }
      let(:subscription) { create(:stripe_subscription, user: user) }

      before do
        create(:stripe_subscribed_plan, subscription: subscription, plan: plan)
      end

      it 'actualizes plan type' do
        expect { call }.to change { user.reload.plan_type }.to('free')
      end
    end

    context 'when user has paid plan' do
      let(:user) { create(:user) }
      let(:plan) { create(:stripe_plan, amount: 100) }
      let(:subscription) { create(:stripe_subscription, user: user) }

      before do
        create(:stripe_subscribed_plan, subscription: subscription, plan: plan)
      end

      it 'actualizes plan type' do
        expect { call }.to change { user.reload.plan_type }.to('paid')
      end
    end
  end
end
