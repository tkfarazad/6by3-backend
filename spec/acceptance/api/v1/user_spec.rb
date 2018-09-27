# frozen_string_literal: true

RSpec.describe 'Users' do
  resource 'Current user endpoint' do
    route '/api/v1/user', 'Current user endpoint' do
      get 'Get current' do
        parameter :include, example: 'paymentSources,defaultPaymentSource,subscriptions'

        let(:include) { 'paymentSources,defaultPaymentSource,subscriptions.plans.product' }

        context 'when user is authenticated', :authenticated_user do
          before do
            create(:stripe_payment_source, user: authenticated_user)
            create(:stripe_payment_source, user: authenticated_user)
            subscription = create(:stripe_subscription, user: authenticated_user)
            plan = create(:stripe_plan)
            create(:stripe_subscribed_plan, subscription: subscription, plan: plan)
          end

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/user')
          end
        end

        context 'when user is not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end
      end

      put 'Update user' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :first_name
          parameter :last_name
          parameter :privacyPolicyAccepted
        end

        let(:type) { 'users' }

        context 'user is not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'when params are invalid', :authenticated_user do
          let(:first_name) { nil }
          let(:last_name) { nil }

          example 'Responds with 400' do
            do_request

            expect(status).to eq(400)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'when params are valid', :authenticated_user do
          let(:user) { authenticated_user }
          let(:first_name) { FFaker::Name.first_name }
          let(:last_name) { FFaker::Name.last_name }
          let(:privacyPolicyAccepted) { true }

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/user')
            expect(user.reload.privacy_policy_accepted).to eq true
            expect(user.reload.first_name).to eq first_name
            expect(user.reload.last_name).to eq last_name
          end
        end
      end

      delete 'Destroys user' do
        context 'when user is not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'when user is authenticated', :authenticated_user do
          example 'Responds with 204' do
            do_request

            expect(status).to eq(204)
            expect(response_body).to be_empty
          end
        end
      end
    end
  end
end
