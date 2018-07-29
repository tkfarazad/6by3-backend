# frozen_string_literal: true

RSpec.describe 'Videos' do
  resource 'Videos' do
    let!(:video1) { create(:video) }
    let!(:video2) { create(:video) }
    let!(:video3) { create(:video, :with_category) }
    let!(:video4) { create(:video, :deleted) } # NOTE: Deleted records are not returned by default
    let!(:category1) { create(:video_category, name: FFaker::Name.name) }

    route '/api/v1/videos{?include}{?sort}', 'Videos endpoint' do
      get 'All videos' do
        parameter :page
        parameter :sort, example: 'created_at'
        parameter :filter
        parameter :include, example: 'category'

        with_options scope: :page do
          parameter :number, required: true
          parameter :size, required: true
        end

        with_options scope: :filter do
          parameter :name
          parameter :duration
        end

        with_options scope: %i[filter duration] do
          parameter :from
          parameter :to
        end

        context 'not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'authenticated user', :authenticated_user do
          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'with category include', :authenticated_user do
          let(:include) { 'category' }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 3
            expect(parsed_body[:included].count).to eq 1
            expect(parsed_body[:included][0][:attributes][:name]).to eq VideoCategory.first.name
          end
        end

        context 'paginated', :authenticated_user do
          let(:number) { 2 }
          let(:size) { 1 }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 1
            expect(parsed_body[:meta]).to be_paginated_resource_meta
            expect(parsed_body[:meta]).to eq(
              current_page: 2,
              next_page: 3,
              prev_page: 1,
              page_count: 3,
              record_count: 3
            )
          end
        end

        context 'sorted', :authenticated_user do
          let(:sort) { '-created_at' }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'filtered', :authenticated_user do
          let(:name) { video1.name }
          let(:from) { 0 }
          let(:to) { 1 }

          example 'Responds with 200' do
            video1.update(duration: 1)

            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 1
          end
        end
      end
    end

    route '/api/v1/videos/:id', 'Video endpoint' do
      get 'Single video' do
        let!(:video) { create(:video) }
        let(:id) { video.id }

        context 'not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'video was not found', :authenticated_user do
          let(:id) { 0 }

          example 'Responds with 404' do
            do_request

            expect(status).to eq(404)
            expect(response_body).to be_empty
          end
        end

        context 'authenticated user', :authenticated_user do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/video')
          end
        end
      end
    end
  end
end
