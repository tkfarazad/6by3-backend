# frozen_string_literal: true

RSpec.describe do
  resource 'Subscriptions', :stripe do
    route '/api/v1/subscriptions/estimate', 'Estimate subscription' do
      post 'Estimate subscription' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :coupon
        end
        with_options scope: %i[data relationships plan data] do
          parameter :id, method: :plan_id
          parameter :type, method: :plan_type
        end

        let(:coupon) { stripe_helper.create_coupon.id }
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

          context 'when coupon is valid' do
            before do
              allow(::Stripe::Invoice).to receive(:upcoming).with(any_args).and_return(Stripe::Invoice.create)
            end

            example_request 'Responds with 200' do
              expect(status).to eq(200)
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

            example_request 'Responds with 422' do
              expect(status).to eq(422)
            end
          end
        end
      end
    end
  end
end
