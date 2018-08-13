# frozen_string_literal: true

RSpec.describe 'Coaches' do
  resource 'Admin coaches' do
    let!(:coach1) { create(:coach, :featured) }
    let!(:coach2) { create(:coach, :featured) }
    let!(:coach3) { create(:coach) }
    let!(:coach4) { create(:coach, :deleted) } # NOTE: Deleted records are not returned by default
    let!(:video1) { create(:video, :with_category) }
    let!(:coaches_video) { create(:coaches_video, video: video1, coach: coach1) }

    route '/api/v1/admin/coaches', 'Admin Coaches endpoint' do
      get 'All coaches' do
        parameter :page
        parameter :sort
        parameter :filter
        parameter :include, example: 'categories'

        with_options scope: :page do
          parameter :number, required: true
          parameter :size, required: true
        end

        with_options scope: :filter do
          parameter :fullname
          parameter :featured
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

        context 'with categories include', :authenticated_admin do
          let(:include) { 'categories' }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 3
            expect(parsed_body[:included].count).to eq 1
            expect(parsed_body[:included][0][:attributes][:name]).to eq video1.category.name
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

        context 'filtered by fullname', :authenticated_admin do
          let(:fullname) { coach1.fullname }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data].count).to eq 1
          end
        end

        context 'filtered by featured', :authenticated_admin do
          let(:featured) { {eq: true} }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/coaches/index')
            expect(parsed_body[:data].count).to eq 2
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
          parameter :featured
        end

        with_options scope: %i[data relationships videos] do
          parameter :data, type: :array, items: {type: :object}, method: :videos_data, required: true
        end

        let(:type) { 'coaches' }

        let!(:coach) { create(:coach) }
        let(:id) { coach.id }
        let(:fullname) { FFaker::Name.name }
        let(:featured) { true }

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

        context 'params are invalid', :authenticated_admin do
          let(:fullname) { nil }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'params are valid', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/coach')
          end
        end

        context 'coach can have multiple video', :authenticated_admin do
          let!(:video1) { create(:video) }
          let!(:video2) { create(:video) }

          let(:videos_data) do
            [
              {type: 'videos', id: video1.id},
              {type: 'videos', id: video2.id}
            ]
          end

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/coach')

            expect(video1.coach_pks).to eq [coach1.id, coach.id]
            expect(video2.coach_pks).to eq [coach.id]

            expect(coach.video_pks).to eq [video1.id, video2.id]
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
