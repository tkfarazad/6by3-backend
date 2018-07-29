# frozen_string_literal: true

RSpec.describe 'Coaches' do
  resource 'coaches' do
    let!(:coach1) { create(:coach) }
    let!(:coach2) { create(:coach) }
    let!(:coach3) { create(:coach) }
    let!(:coach4) { create(:coach, :deleted) } # NOTE: Deleted records are not returned by default

    route '/api/v1/coaches', 'Coaches endpoint' do
      get 'All coaches' do
        parameter :page
        parameter :sort
        parameter :filter

        with_options scope: :page do
          parameter :number, required: true
          parameter :size, required: true
        end

        with_options scope: :filter do
          parameter :fullname
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

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'paginated', :authenticated_user do
          let(:number) { 2 }
          let(:size) { 1 }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/coaches/index')
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

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'filtered', :authenticated_user do
          let(:fullname) { coach1.fullname }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data].count).to eq 1
          end
        end
      end
    end

    route '/api/v1/coaches/:id', 'Coach endpoint' do
      get 'Single coach' do
        let!(:coach) { create(:coach) }
        let(:id) { coach.id }

        context 'not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'coach was not found', :authenticated_user do
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
            expect(response_body).to match_response_schema('v1/coach')
          end
        end
      end
    end
  end
end
