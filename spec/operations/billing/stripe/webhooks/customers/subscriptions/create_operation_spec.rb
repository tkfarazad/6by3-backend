# frozen_string_literal: true

RSpec.describe Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(user: user, subscription: subscription)
  end

  let!(:user) { create(:user) }
  let(:event) { StripeMock.mock_webhook_event('customer.subscription.created') }

  let!(:subscription) { create(:stripe_subscription, stripe_id: event.data.object.id) }
  let!(:plan) { create(:stripe_plan, stripe_id: event.data.object.id) }

  before do
    create(:stripe_subscribed_plan, subscription: subscription, plan: plan)
  end

  context 'when customer subscription is created' do
    context 'when subscription is trial' do
      before do
        subscription.update(status: SC::Billing::Stripe::Subscription::TRIAL_STATUS)
      end

      let(:first_payment_date) { Time.now.strftime('%B %d, %Y') }
      let(:next_payment_date) { 1.month.from_now.strftime('%B %d, %Y') }

      context 'when interval is month' do
        it 'enqueues email' do
          expect { call }.to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
              .with(
                'UserMailer',
                'free_trial_start',
                'deliver_now',
                hash_including(:email, :first_payment_date, :next_payment_date)
              )
          )
        end
      end

      context 'when interval is year' do
        before do
          plan.update(interval: 'year')
        end

        let(:next_payment_date) { 1.year.from_now.strftime('%B %d, %Y') }

        it 'enqueues email' do
          expect { call }.to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
              .with(
                'UserMailer',
                'free_trial_start',
                'deliver_now',
                hash_including(:email, :first_payment_date, :next_payment_date)
              )
          )
        end
      end
    end

    context 'when subscription is not trial' do
      context 'when plan free' do
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

      context 'when plan is not free' do
        it 'does not enqueues email' do
          expect { call }.not_to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
          )
        end
      end
    end
  end
end
