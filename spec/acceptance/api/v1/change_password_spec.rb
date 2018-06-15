# frozen_string_literal: true

RSpec.describe 'Change password' do
  resource 'Change password request' do
    route '/api/v1/change_password', 'Change password' do
      post 'Change password' do
        with_options scope: %i[data attributes] do
          parameter :token, required: true
          parameter :password, required: true
          parameter :passwordConfirmation, required: true
        end

        let(:token) { SecureRandom.uuid }
        let(:password) { FFaker::Internet.password }
        let(:passwordConfirmation) { password }

        context 'when token is valid' do
          before do
            create(:user, :reset_password_requested, reset_password_token: token)
          end

          context 'when password is valid' do
            example 'Responds with 200' do
              do_request

              expect(status).to eq(200)
            end
          end

          context 'when password is not valid' do
            let(:passwordConfirmation) { '' }

            example 'Responds with 422' do
              do_request

              expect(status).to eq(422)
              expect(response_body).to match_json_schema('v1/error')
            end
          end
        end

        context 'when token is not valid' do
          example 'Responds with 404' do
            do_request

            expect(status).to eq(404)
          end
        end
      end
    end
  end
end
