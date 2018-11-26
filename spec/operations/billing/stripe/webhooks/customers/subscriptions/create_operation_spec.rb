# frozen_string_literal: true

RSpec.describe Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event: event, user: user)
  end

  let!(:user) { create(:user) }
  let(:event) { StripeMock.mock_webhook_event('customer.created') }

  let!(:subscription) { create(:stripe_subscription, stripe_id: event.data.object.id) }
  let!(:plan) { create(:stripe_plan, stripe_id: event.data.object.id) }

  before do
    create(:stripe_subscribed_plan, subscription: subscription, plan: plan)
  end

  context 'when customer created' do
    context 'when subscription is trial' do
      before do
        subscription.update(status: SC::Billing::Stripe::Subscription::TRIAL_STATUS)
      end

      it 'enqueues email' do
        expect { call }.to(
          have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
            .with(
              'AdminMailer',
              'free_trial_user_created',
              'deliver_now',
              hash_including(:email, :name)
            )
        )
      end
    end

    context 'when plan is free' do
      before do
        plan.update(amount: 0)
      end

      it 'enqueues email' do
        expect { call }.to(
          have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
            .with(
              'UserMailer',
              'free_user_created',
              'deliver_now',
              hash_including(:email, :name)
            )
        )
      end
    end

    context 'when plan is free and subscription is trial' do
      before do
        plan.update(amount: 0)
        subscription.update(status: SC::Billing::Stripe::Subscription::TRIAL_STATUS)
      end

      it 'enqueues email' do
        expect { call }.to(
          have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
            .with(
              'AdminMailer',
              'free_trial_user_created',
              'deliver_now',
              hash_including(:email, :name)
            ).and(
              have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
                .with(
                  'UserMailer',
                  'free_user_created',
                  'deliver_now',
                  hash_including(:email, :name)
                )
            )
        )
      end
    end

    context 'when subscription is not in trial and not free' do
      it 'enqueues email' do
        expect { call }.to(
          not_have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
        )
      end
    end
  end
end
