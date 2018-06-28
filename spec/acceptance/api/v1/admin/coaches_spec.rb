# frozen_string_literal: true

RSpec.describe 'Coaches' do
  resource 'Admin coaches' do
    let!(:coach1) { create(:coach) }
    let!(:coach2) { create(:coach) }
    let!(:coach3) { create(:coach) }

    route '/api/v1/admin/coaches', 'Admin Coaches endpoint' do
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
          example 'Responds with 403' do
            do_request

            expect(status).to eq(403)
          end
        end

        context 'authenticated admin', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'paginated', :authenticated_admin do
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

        context 'sorted', :authenticated_admin do
          let(:sort) { '-created_at' }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'filtered', :authenticated_admin do
          let(:fullname) { coach1.fullname }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data].count).to eq 1
          end
        end
      end

      post 'Create coach' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :fullname, required: true
        end

        let(:type) { 'coaches' }
        let(:fullname) { FFaker::Name.name }

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

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data][:attributes][:fullname]).to eq fullname
          end
        end

        context 'when params are invalid', :authenticated_admin do
          let(:fullname) { nil }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end
      end
    end

    route '/api/v1/admin/coaches/:id', 'Admin Coach endpoint' do
      get 'Single coach' do
        let!(:coach) { create(:coach) }
        let(:id) { coach.id }

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

        context 'coach was not found', :authenticated_admin do
          let(:id) { 0 }

          example 'Responds with 404' do
            do_request

            expect(status).to eq(404)
            expect(response_body).to be_empty
          end
        end

        context 'authenticated admin', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/coach')
          end
        end
      end

      put 'Update coach' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :fullname
        end

        let(:type) { 'coaches' }

        let!(:coach) { create(:coach) }
        let(:id) { coach.id }

        context 'not authenticated' do
          let(:fullname) { FFaker::Name.name }

          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'not admin', :authenticated_user do
          let(:fullname) { FFaker::Name.name }

          example 'Responds with 403' do
            do_request

            expect(status).to eq(403)
          end
        end

        context 'params are invalid', :authenticated_admin do
          let(:fullname) { nil }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'params are valid', :authenticated_admin do
          let(:fullname) { FFaker::Name.name }

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/coach')
          end
        end
      end

      delete 'Destroy coach' do
        let!(:coach) { create(:coach) }
        let(:id) { coach.id }

        context 'not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'not admin', :authenticated_user do
          example 'Responds with 403' do
            do_request

            expect(status).to eq(403)
          end
        end

        context 'is admin', :authenticated_admin do
          example 'Responds with 204' do
            do_request

            expect(status).to eq(204)
          end
        end
      end
    end
  end
end
