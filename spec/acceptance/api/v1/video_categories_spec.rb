# frozen_string_literal: true

RSpec.describe 'Video Categories' do
  resource 'video_categories' do
    let!(:video_category1) { create(:video_category, name: FFaker::Name.name) }
    let!(:video_category2) { create(:video_category, name: FFaker::Name.name) }
    let!(:video_category3) { create(:video_category, name: FFaker::Name.name) }

    route '/api/v1/video_categories', 'Video Categories endpoint' do
      get 'All video categories' do
        parameter :page
        parameter :sort
        parameter :filter

        with_options scope: :page do
          parameter :number, required: true
          parameter :size, required: true
        end

        with_options scope: :filter do
          parameter :name
        end

        context 'returns all records with no params' do
          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/video_categories/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'paginated' do
          let(:number) { 2 }
          let(:size) { 1 }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/video_categories/index')
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

        context 'sorted' do
          let(:sort) { '-created_at' }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/video_categories/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'filtered' do
          let(:name) { video_category1.name }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/video_categories/index')
            expect(parsed_body[:data].count).to eq 1
          end
        end
      end
    end

    route '/api/v1/video_categories/:id', 'Video Category endpoint' do
      get 'Single coach' do
        let(:id) { video_category1.id }

        context 'video category was not found' do
          let(:id) { 0 }

          example 'Responds with 404' do
            do_request

            expect(status).to eq(404)
            expect(response_body).to be_empty
          end
        end

        context 'returns user' do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/video_category')
          end
        end
      end
    end
  end
end
