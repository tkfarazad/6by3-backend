# frozen_string_literal: true

RSpec.describe 'Video sign' do
  resource 'Video sign endpoint' do
    route '/api/v1/admin/videos/sign{?size}{?content_type}{?name}', 'Video sign URL' do
      get 'Signed URL' do
        parameter :size, 1_000_000, required: true, with_example: true, type: :integer
        parameter :content_type, 'video/mp4', required: true, with_example: true, type: :string
        parameter :name, 'i_am_batman.mp4', required: true, with_example: true, type: :string

        let(:size) { 5.megabyte }
        let(:content_type) { ::SixByThree::Constants::AVAILABLE_UPLOAD_VIDEO_CONTENT_TYPES.sample }
        let(:name) { FFaker::Video.name }

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

        context 'authenticated admin', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/sign')
            expect(status).to eq(200)
          end
        end

        context 'empty name', :authenticated_admin do
          let(:name) { nil }

          example 'Responds with 422' do
            do_request

            expect(response_body).to match_response_schema('v1/error')
            expect(status).to eq(422)
          end
        end

        context 'invalid content type', :authenticated_admin do
          let(:content_type) { 'lorem/ipsum' }

          example 'Responds with 422' do
            do_request

            expect(response_body).to match_response_schema('v1/error')
            expect(status).to eq(422)
          end
        end

        context 'file size limit', :authenticated_admin do
          context 'is to small' do
            let(:size) { 0.bytes }

            example 'Responds with 422' do
              do_request

              expect(response_body).to match_response_schema('v1/error')
              expect(status).to eq(422)
            end
          end

          context 'is to big' do
            let(:size) { 1.exabyte }

            example 'Responds with 422' do
              do_request

              expect(response_body).to match_response_schema('v1/error')
              expect(status).to eq(422)
            end
          end
        end
      end
    end
  end
end
