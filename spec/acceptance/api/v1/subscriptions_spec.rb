# frozen_string_literal: true

RSpec.describe do
  resource 'Subscriptions', :stripe do
    route '/api/v1/subscriptions/', 'Subscriptions endpoint' do
      post 'Create subscription' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :coupon
        end
        with_options scope: %i[data relationships plan data] do
          parameter :id, method: :plan_id
          parameter :type, method: :plan_type
        end

        let(:coupon) { 'coupon' }
        let(:type) { 'subscriptions' }
        let(:plan_type) { 'plans' }
        let(:plan_id) { plan.id.to_s }

        let(:stripe_plan) { stripe_helper.create_plan }
        let(:plan) { create(:stripe_plan, stripe_id: stripe_plan.id) }

        it_behaves_like '401 when user is not authenticated'

        context 'when user is authenticated', authenticated_user: true do
          let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
          let(:stripe_subscription) { Stripe::Subscription.create(customer: stripe_customer.id) }
          let(:authenticated_user) { create(:user, stripe_customer_id: stripe_customer.id) }

          example_request 'Responds with 201' do
            expect(status).to eq(201)
          end
        end
      end
    end
  end
end
