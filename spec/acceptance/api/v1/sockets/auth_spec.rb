# frozen_string_literal: true

RSpec.describe 'Sockets Authenticate' do
  resource 'Sockets authenticate endpoint' do
    route '/api/v1/sockets/auth', 'Sockets authenticate' do
      before(:each) do
        header 'Content-Type', 'application/json'
      end

      post 'Sockets Authenticate' do
        parameter :socket_id, required: true
        parameter :channel_name, required: true

        let!(:user) { create(:user) }
        let(:channel_name) { "private-users.#{user.id}" }
        let(:socket_id) { '1.1' }

        context 'when user is not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'when user authenticated', :authenticated_user do
          context 'when params are invalid' do
            let(:channel_name) { 'lorem' }

            example 'Responds with 422' do
              do_request

              expect(status).to eq(422)
              expect(response_body).to match_response_schema('v1/error')
            end
          end

          context 'when try to get auth of another user channel' do
            it 'responds with 403' do
              do_request

              expect(status).to eq(403)
            end
          end

          context 'when try to get auth of own channel' do
            let(:user) { authenticated_user }

            example 'Responds with 200' do
              do_request

              expect(status).to eq(200)
              expect(response_body['auth']).to be
            end
          end
        end
      end
    end
  end
end
