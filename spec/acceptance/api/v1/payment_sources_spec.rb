# frozen_string_literal: true

RSpec.describe do
  resource 'Payment sources', :stripe do
    route '/api/v1/payment_sources', 'Payment sources' do
      post 'Create payment source' do
        with_options scope: %i[data attributes] do
          parameter :token, required: true
        end

        let(:token) { stripe_helper.generate_card_token }

        it_behaves_like '401 when user is not authenticated'

        context 'when user is authenticated', authenticated_user: true do
          context 'when params are invalid' do
            let(:token) { nil }

            example_request 'Responds with 422' do
              expect(status).to eq(422)
              expect(response_body).to match_response_schema('v1/error')
            end
          end

          context 'when user does not have stripe_customer_id' do
            example_request 'Responds with 201' do
              expect(status).to eq(201)
            end
          end

          context 'when user has stripe_customer_id' do
            let(:stripe_customer) { Stripe::Customer.create }
            let(:authenticated_user) { create(:user, stripe_customer_id: stripe_customer.id) }

            example_request 'Responds with 201', document: false do
              expect(status).to eq(201)
            end
          end
        end
      end
    end

    route '/api/v1/payment_sources/:id', 'Payment source' do
      delete 'Delete payment source' do
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

            example_request 'Responds with 204' do
              expect(status).to eq(204)
            end
          end
        end
      end
    end
  end
end
