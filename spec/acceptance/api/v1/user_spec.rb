# frozen_string_literal: true

RSpec.describe 'Users' do
  resource 'Current user endpoint' do
    route '/api/v1/user', 'Current user endpoint' do
      get 'Get current' do
        parameter :include

        context 'when user is authenticated', :auth do
          example 'Responds with 200', :aggregate_failures do
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
    end
  end
end
