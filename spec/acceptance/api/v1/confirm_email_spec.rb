# frozen_string_literal: true

RSpec.describe 'Email confirmation' do
  resource 'Confirm email' do
    route '/api/v1/confirm_email', 'Confirm user email' do
      post 'Confirm email' do
        with_options scope: %i[data attributes] do
          parameter :token, required: true
        end

        let(:token) { SecureRandom.hex }
        let(:email) { FFaker::Internet.email }

        context 'when user does not exist' do
          example 'Responds with 404' do
            do_request

            expect(status).to eq(404)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'when token is invalid' do
          let!(:user) do
            create(
              :user,
              :unconfirmed,
              email_confirmation_token: token,
              email_confirmation_requested_at: Time.current - 5.days
            )
          end

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'when token is valid' do
          before do
            create(:user, :unconfirmed, email_confirmation_token: token)
          end

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
          end
        end
      end
    end
  end
end
