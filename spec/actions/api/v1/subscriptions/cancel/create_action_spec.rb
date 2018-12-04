# frozen_string_literal: true

RSpec.describe Api::V1::Subscriptions::Cancel::CreateAction, :stripe do
  let(:event) { StripeMock.mock_webhook_event('customer.subscription.deleted') }
  let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
  let(:item_plan) { stripe_helper.create_plan }
  let!(:plan) { create(:stripe_plan, stripe_id: event.data.object.id, amount: 0) }
  let(:stripe_subscription) { Stripe::Subscription.create(customer: stripe_customer.id, items: [plan: item_plan.id]) }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:subscription) { create(:stripe_subscription, :trialing, user: user, stripe_id: stripe_subscription.id) }
  let(:action) { described_class.new(context: {current_user: user}) }

  describe '#call' do
    subject(:call) do
      action.call(subscription_id: subscription.id)
    end

    before do
      create(:stripe_subscribed_plan, subscription: subscription, plan: plan)
    end

    it 'enqueues mailer and customer io jobs' do
      expect { call }.to(
        have_enqueued_job(Customerio::IdentifyUserJob).with(user_id: user.id)
          .and(have_enqueued_job(Customerio::TrackJob).with(user_id: user.id, event: 'free-trial-cancelled'))
          .and(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
              .with(
                'UserMailer',
                'subscription_cancelled',
                'deliver_now',
                hash_including(:email, :name, :end_date)
              )
          )
      )
    end
  end
end
