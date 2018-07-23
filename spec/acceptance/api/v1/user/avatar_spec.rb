# frozen_string_literal: true

RSpec.describe 'User Avatar' do
  resource 'Current user avatar endpoint' do
    route '/api/v1/user/avatar', 'Current user avatar' do
      post 'Create Avatar' do
        let(:raw_post) { params }
        let(:avatar) { fixture_file_upload('spec/fixtures/files/image.png', 'image/png') }

        parameter :avatar, required: true

        context 'when params are valid', :authenticated_user do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/user')
          end
        end

        context 'when avatar file format is invalid', :authenticated_user do
          let(:avatar) { fixture_file_upload('spec/fixtures/files/image.svg', 'image/svg+xml') }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end
      end

      put 'Update Avatar' do
        let(:raw_post) { params }
        let(:avatar) { fixture_file_upload('spec/fixtures/files/image.png', 'image/png') }

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
