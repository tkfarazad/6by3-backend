# frozen_string_literal: true

RSpec.describe do
  resource 'Payment sources', :stripe do
    route '/api/v1/payment_sources/:id/make_default', 'Make payment source as a default' do
      post 'Set payment source as a default' do
        parameter :id, required: true

        let(:id) { payment_source.id }
        let(:payment_source) { create(:stripe_payment_source) }

        it_behaves_like '401 when user is not authenticated'

        context 'when user is authenticated', authenticated_user: true do
          let(:stripe_customer) { Stripe::Customer.create }
          let(:authenticated_user) { create(:user, stripe_customer_id: stripe_customer.id) }

          context 'when user does not have permissions' do
            example_request 'Responds with 403' do
              expect(status).to eq(403)
            end
          end

          context 'when user has permissions' do
            let(:stripe_payment_source) { stripe_customer.sources.create(source: stripe_helper.generate_card_token) }
            let(:payment_source) do
              create(:stripe_payment_source, user: authenticated_user, stripe_id: stripe_payment_source.id)
            end

            example 'Responds with 200' do
              expect { do_request }.to change { authenticated_user.reload.default_payment_source }.to(payment_source)

              expect(status).to eq(200)
            end
          end
        end
      end
    end
  end
end
