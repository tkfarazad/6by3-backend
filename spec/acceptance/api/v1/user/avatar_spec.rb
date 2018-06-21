# frozen_string_literal: true

RSpec.describe 'User Avatar' do
  resource 'Current user avatar endpoint' do
    route '/api/v1/user/avatar', 'Create avatar' do
      post 'Create Avatar' do
        let(:raw_post) { params }
        let(:avatar) { fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png') }

        parameter :avatar, required: true

        context 'user avatar is created', :authenticated_user do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/user')
          end
        end
      end

      put 'Update Avatar' do
        let(:raw_post) { params }
        let(:avatar) { fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png') }

        parameter :avatar, required: true

        context 'user avatar is update', :authenticated_user do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/user')
          end
        end
      end

      delete 'Destroy Avatar' do
        context 'user avatar is destroyed(removed)', :authenticated_user do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/user')
            expect(authenticated_user.avatar.present?).to be_falsey
          end
        end
      end
    end
  end
end
