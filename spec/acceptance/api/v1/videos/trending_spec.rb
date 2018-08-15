# frozen_string_literal: true

RSpec.describe 'Featured Videos endpoint' do
  resource 'Featured Videos' do
    route '/api/v1/videos/trending', 'Trending Videos endpoint' do
      let!(:video1) { create(:video) }
      let!(:video2) { create(:video) }
      let!(:video3) { create(:video) }
      let!(:video4) { create(:video) }

      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let!(:user4) { create(:user) }

      # TODO: Add tests to test date range
      get 'Get all trending videos' do
        context 'user authenticated', :authenticated_user do
          context 'returns all records with' do
            example 'Responds with 200' do
              [video1, video2, video3, video4].each { |video| create(:video_view, user: user1, video: video) }
              [video1, video2, video3].each { |video| create(:video_view, user: user2, video: video) }
              [video1, video2].each { |video| create(:video_view, user: user3, video: video) }
              [video1].each { |video| create(:video_view, user: user4, video: video) }

              do_request

              expect(status).to eq(200)
              expect(response_body).to match_response_schema('v1/videos/index')
              expect(parsed_body[:data].count).to eq 4

              expect(parsed_body[:data][0][:id]).to eq_id video1.id
              expect(parsed_body[:data][1][:id]).to eq_id video2.id
              expect(parsed_body[:data][2][:id]).to eq_id video3.id
              expect(parsed_body[:data][3][:id]).to eq_id video4.id

              expect(parsed_body[:meta]).to be_paginated_resource_meta
              expect(parsed_body[:meta]).to eq(
                current_page: 1,
                next_page: nil,
                prev_page: nil,
                page_count: 1,
                record_count: 4
              )
            end
          end
        end
      end
    end
  end
end
