# frozen_string_literal: true

RSpec.describe 'Resend email confirmation' do
  resource 'Confirm email' do
    route '/api/v1/resend_confirm_email', 'Confirm user email' do
      post 'Confirm email' do
        with_options scope: %i[data attributes] do
          parameter :email, required: true
        end

        let(:email) { FFaker::Internet.email }

        context 'when email does not exist' do
          example 'Responds with 200', document: false do
            do_request

            expect(status).to eq(200)
          end
        end

        context 'when emails exists' do
          before do
            create(:user, email: email)
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
