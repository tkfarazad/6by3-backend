# frozen_string_literal: true

RSpec.describe do
  resource 'Subscriptions', :stripe do
    route '/api/v1/subscriptions/:id/cancel', 'Cancel subscription' do
      post 'Cancel subscription' do
        parameter :id, required: true

        let(:id) { subscription.id }
        let(:subscription) { create(:stripe_subscription, :active) }

        it_behaves_like '401 when user is not authenticated'

        context 'when user is authenticated', authenticated_user: true do
          let(:event) { StripeMock.mock_webhook_event('customer.subscription.deleted') }
          let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
          let(:item_plan) { stripe_helper.create_plan }
          let!(:plan) { create(:stripe_plan, stripe_id: event.data.object.id) }
          let(:stripe_subscription) do
            Stripe::Subscription.create(customer: stripe_customer.id, items: [plan: item_plan.id])
          end
          let(:authenticated_user) { create(:user, stripe_customer_id: stripe_customer.id) }

          before do
            create(:stripe_subscribed_plan, subscription: subscription, plan: plan)
          end

          it_behaves_like '403 when user does not have permissions'

          context 'when user has permissions' do
            let(:subscription) do
              create(:stripe_subscription, :active, user: authenticated_user, stripe_id: stripe_subscription.id)
            end

            example_request 'Responds with 200' do
              expect(status).to eq(200)
            end
          end
        end
      end
    end
  end
end
