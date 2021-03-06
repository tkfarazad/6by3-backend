# frozen_string_literal: true

RSpec.describe 'User tokens' do
  resource 'Generate user token' do
    route '/api/v1/user/tokens', 'Generate user token' do
      post 'Generate user token' do
        context 'when authenticate by email and password' do
          with_options scope: %i[data attributes] do
            parameter :email, required: true
            parameter :password, required: true
          end

          let(:email) { FFaker::Internet.email }
          let(:password) { FFaker::Internet.password }

          context 'when authentication has been failed' do
            example 'Responds with 404' do
              do_request

              expect(status).to eq(404)
            end
          end

          context 'when authenticated has been succeded' do
            before do
              create(:user, :confirmed, email: email, password: password, password_confirmation: password)
            end

            example 'Responds with 201' do
              do_request

              expect(status).to eq(201)
              expect(response_body).to match_response_schema('v1/user/token')
            end
          end
        end

        context 'when authenticate by auth token' do
          parameter :token, required: true, scope: %i[data attributes]

          let(:token) { SecureRandom.uuid }

          context 'when authentication has been failed' do
            example 'Responds with 404' do
              do_request

              expect(status).to eq(404)
            end
          end

          context 'when authenticated has been succeded' do
            let!(:user) { create(:user, :confirmed) }

            before do
              create(:auth_token, token: token, user: user)
            end

            example 'Responds with 201' do
              do_request

              expect(status).to eq(201)
              expect(response_body).to match_response_schema('v1/user/token')
            end
          end
        end
      end
    end
  end
end
