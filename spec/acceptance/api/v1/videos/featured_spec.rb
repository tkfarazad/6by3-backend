# frozen_string_literal: true

RSpec.describe 'Featured Videos endpoint' do
  resource 'Featured Videos' do
    let!(:video1) { create(:video, :featured) }
    let!(:video2) { create(:video, :featured) }
    let!(:video3) { create(:video, :featured) }
    let!(:video4) { create(:video) }

    route '/api/v1/videos/featured', 'Featured Videos endpoint' do
      get 'Get all featured videos' do
        context 'returns all records with' do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end
      end
    end

    route '/api/v1/videos/featured/:id', 'Featured Video endpoint' do
      get 'Single featured video' do
        let(:id) { video1.id }

        context 'returns record by id' do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/video')
            expect(parsed_body[:data][:id]).to eq_id video1.id
          end
        end

        context 'video was not found' do
          let(:id) { 0 }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end
      end
    end
  end
end
