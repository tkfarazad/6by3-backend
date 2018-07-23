# frozen_string_literal: true

RSpec.describe 'Video thumbnail' do
  resource 'Video thumbnail endpoint' do
    route '/api/v1/admin/videos/:id/thumbnail', 'Video thumbnail' do
      let!(:video) { create(:video) }
      let(:id) { video.id }

      post 'Create Thumbnail' do
        let(:raw_post) { params }
        let(:thumbnail) { fixture_file_upload('spec/fixtures/files/image.png', 'image/png') }

        parameter :thumbnail, required: true

        context 'when params are valid', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(parsed_body[:data][:type]).to eq 'videos'
            expect(response_body).to match_response_schema('v1/video')
          end
        end

        context 'when file format is invalid', :authenticated_admin do
          let(:thumbnail) { fixture_file_upload('spec/fixtures/files/image.svg', 'image/svg+xml') }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end
      end

      put 'Update Thumbnail' do
        let(:raw_post) { params }
        let(:thumbnail) { fixture_file_upload('spec/fixtures/files/image.png', 'image/png') }

        parameter :thumbnail, required: true

        context 'when params are valid', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(parsed_body[:data][:type]).to eq 'videos'
            expect(response_body).to match_response_schema('v1/video')
          end
        end

        context 'when file format is invalid', :authenticated_admin do
          let(:thumbnail) { fixture_file_upload('spec/fixtures/files/image.svg', 'image/svg+xml') }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end
      end

      delete 'Destroy Thumbnail' do
        context 'video thumbnail is destroyed(removed)', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(parsed_body[:data][:type]).to eq 'videos'
            expect(response_body).to match_response_schema('v1/video')
            expect(video.thumbnail.present?).to be_falsey
          end
        end
      end
    end
  end
end
