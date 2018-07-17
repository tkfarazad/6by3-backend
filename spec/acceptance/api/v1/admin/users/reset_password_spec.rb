# frozen_string_literal: true

RSpec.describe 'Admin User Reset password' do
  resource 'Reset password request' do
    route '/api/v1/admin/users/:id/reset_password', 'Reset password' do
      let!(:user) { create(:user) }
      let(:id) { user.id }

      post 'Reset password' do
        context 'not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'authenticated user', :authenticated_user do
          example 'Responds with 403' do
            do_request

            expect(status).to eq(403)
          end
        end

        context 'when user does not exist', :authenticated_admin do
          let(:id) { 0 }

          example 'Responds with 404' do
            do_request

            expect(status).to eq(404)
          end
        end

        context 'when user exist', :authenticated_admin do
          let(:id) { user.id }

          example 'Responds with 202' do
            do_request

            expect(status).to eq(202)
          end
        end
      end
    end
  end
end
