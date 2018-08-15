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
          let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
          let(:stripe_subscription) { Stripe::Subscription.create(customer: stripe_customer.id) }
          let(:authenticated_user) { create(:user, stripe_customer_id: stripe_customer.id) }

          it_behaves_like '403 when user does not have permissions'

          context 'when user has permissions' do
            let(:subscription) do
              create(:stripe_subscription, :active, user: authenticated_user, stripe_id: stripe_subscription.id)
            end

            example 'Responds with 200', :aggregate_failures do
              expect { do_request }.to change { subscription.reload.status }.to('canceled')

              expect(status).to eq(200)
            end
          end
        end
      end
    end
  end
end
