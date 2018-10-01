# frozen_string_literal: true

RSpec.describe 'Users' do
  resource 'Users endpoint' do
    route '/api/v1/users', 'Users endpoint' do
      post 'Create user' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :email, required: true
          parameter :firstName, required: true
          parameter :lastName, required: true
          parameter :password, required: true
          parameter :passwordConfirmation, required: true
        end

        let(:type) { 'users' }
        let(:email) { FFaker::Internet.email }
        let(:firstName) { FFaker::Name.first_name }
        let(:lastName) { FFaker::Name.last_name }
        let(:password) { FFaker::Internet.password }
        let(:passwordConfirmation) { password }

        context 'when user created' do
          example 'Responds with 202' do
            do_request

            expect(status).to eq(202)
          end
        end

        context 'when params are invalid' do
          let(:password) { nil }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'when user already exists' do
          before do
            create(:user, email: email)
          end

          example 'Responds with 202' do
            do_request

            expect(status).to eq(202)
          end
        end
      end
    end
  end
end
