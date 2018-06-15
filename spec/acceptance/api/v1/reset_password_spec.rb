# frozen_string_literal: true

RSpec.describe 'Reset password' do
  resource 'Reset password request' do
    route '/api/v1/reset_password', 'Reset password' do
      post 'Reset password' do
        with_options scope: %i[data attributes] do
          parameter :email, required: true
        end

        let(:email) { FFaker::Internet.email }

        context 'when emails exists' do
          before do
            create(:user, email: email)
          end

          example 'Responds with 202' do
            do_request

            expect(status).to eq(202)
          end
        end

        context 'when email does not exist' do
          example 'Responds with 202', document: false do
            do_request

            expect(status).to eq(202)
          end
        end
      end
    end
  end
end
