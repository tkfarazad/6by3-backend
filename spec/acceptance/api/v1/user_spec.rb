# frozen_string_literal: true

RSpec.describe 'Users' do
  resource 'Current user endpoint' do
    route '/api/v1/user', 'Current user endpoint' do
      get 'Get current' do
        parameter :include

        context 'when user is authenticated', :authenticated_user do
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
          parameter :fullname
        end

        let(:type) { 'users' }

        context 'user is not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'when params are invalid', :authenticated_user do
          let(:fullname) { nil }

          example 'Responds with 400' do
            do_request

            expect(status).to eq(400)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'when params are valid', :authenticated_user do
          let(:fullname) { FFaker::Name.name }

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/user')
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
