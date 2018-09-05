# frozen_string_literal: true

RSpec.describe 'Videos' do
  resource 'Admin videos' do
    let!(:video1) { create(:video) }
    let!(:video2) { create(:video) }
    let!(:video3) { create(:video, :with_category) }
    let!(:video4) { create(:video, :deleted) } # NOTE: Deleted records are not returned by default
    let!(:coach1) { create(:coach) }
    let!(:coach2) { create(:coach) }
    let!(:coaches_video) { create(:coaches_video, video: video1, coach: coach1) }
    let!(:category1) { create(:video_category, name: FFaker::Name.name) }
    let!(:category2) { create(:video_category, name: FFaker::Name.name) }

    # IDEA: This should be somehow be improved/replaced
    # In current way it only polutes `route` param for us(devs)
    # As all possible sorting, filtering, and pagination params are known
    # We need to somehow overrided this method to rebuild first param
    # In the needed direction
    # As as it grows it will becam too long
    # Example for what we have now:
    # '/api/v1/admin/videos{?include}{?sort}{?filter[name]}{?page[number]}{?page[size]}'
    route '/api/v1/admin/videos{?include}{?sort}', 'Admin Videos endpoint' do
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
          parameter :coach
          parameter :category
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
          example 'Responds with 403' do
            do_request

            expect(status).to eq(403)
          end
        end

        context 'authenticated admin', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'with category include', :authenticated_admin do
          let(:include) { 'category' }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 3
            expect(parsed_body[:included].count).to eq 1
            expect(parsed_body[:included][0][:attributes][:name]).to eq VideoCategory.first.name
          end
        end

        context 'paginated', :authenticated_admin do
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

        context 'sorted', :authenticated_admin do
          let(:sort) { '-created_at' }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'filtered', :authenticated_admin do
          context 'by duration' do
            let(:from) { 0 }
            let(:to) { 1 }

            example 'Responds with 200' do
              video1.update(duration: 1)

              do_request

              expect(response_body).to match_response_schema('v1/videos/index')
              expect(parsed_body[:data].count).to eq 1
            end
          end

          context 'by category' do
            let(:category) { [category1.id, category2.id] }

            example 'Responds with 200' do
              video2.update(category: category2)

              do_request

              expect(response_body).to match_response_schema('v1/videos/index')
              expect(parsed_body[:data].count).to eq 1
              expect(parsed_body[:data][0][:id]).to eq_id video2.id
            end
          end

          context 'by coach' do
            let(:coach) { [coach1.id, coach2.id] }

            example 'Responds with 200' do
              do_request

              expect(response_body).to match_response_schema('v1/videos/index')
              expect(parsed_body[:data].count).to eq 1
              expect(parsed_body[:data][0][:id]).to eq_id video1.id
            end
          end
        end
      end

      post 'Create video' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :url, required: true
          parameter :description, required: true
          parameter :name, required: true
          parameter :content_type, required: true
        end

        let(:type) { 'users' }

        let(:name) { FFaker::Video.name }
        let(:url) { 'http://127.0.0.1:3000/video.mp4' }
        let(:content_type) { ::SixByThree::Constants::AVAILABLE_UPLOAD_VIDEO_CONTENT_TYPES.sample }
        let(:description) { FFaker::Book.description }

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
          example 'Responds with 201' do
            do_request

            expect(status).to eq(201)
            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data][:attributes][:name]).to eq name
          end
        end

        context 'when params are invalid', :authenticated_admin do
          let(:name) { nil }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'when invalid video type', :authenticated_admin do
          let(:content_type) { 'lorem/ipsum' }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end
      end

      delete 'Destroy video' do
        parameter :data, type: :array, items: {type: :object}, required: true

        let!(:video1) { create(:video) }
        let!(:video2) { create(:video) }

        let(:data) do
          [
            {type: 'videos', id: video1.id},
            {type: 'videos', id: video2.id}
          ]
        end

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

    route '/api/v1/admin/videos/:id', 'Admin Video endpoint' do
      get 'Single video' do
        let!(:video) { create(:video) }
        let(:id) { video.id }

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

        context 'video was not found', :authenticated_admin do
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
            expect(response_body).to match_response_schema('v1/video')
          end
        end
      end

      put 'Update video' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :name
          parameter :description
          parameter :lesson_date
        end

        with_options scope: %i[data relationships category data] do
          parameter :id, method: :category_id
          parameter :type, method: :category_type
        end

        with_options scope: %i[data relationships coaches] do
          parameter :data, type: :array, items: {type: :object}, method: :coaches_data, required: true
        end

        let(:type) { 'videos' }

        let!(:video) { create(:video) }
        let(:id) { video.id }

        context 'not authenticated' do
          let(:name) { FFaker::Name.name }

          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'not admin', :authenticated_user do
          let(:name) { FFaker::Name.name }

          example 'Responds with 403' do
            do_request

            expect(status).to eq(403)
          end
        end

        context 'params are invalid', :authenticated_admin do
          let(:name) { nil }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'params are valid', :authenticated_admin do
          let(:name) { FFaker::Name.name }
          let(:description) { FFaker::Book.description }
          let(:lesson_date) { Time.current }

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/video')
          end
        end

        context 'association video category', :authenticated_admin do
          let(:category_id) { category1.id }
          let(:category_type) { 'categories' }

          example 'Responds with 200' do
            do_request

            video.reload

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/video')

            expect(video.category).to eq category1
            expect(category1.videos).to eq [video]
          end
        end

        context 'video can have multiple coaches', :authenticated_admin do
          let!(:coach1) { create(:coach) }
          let!(:coach2) { create(:coach) }

          let(:coaches_data) do
            [
              {type: 'coaches', id: coach1.id},
              {type: 'coaches', id: coach2.id}
            ]
          end

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/video')

            expect(coach1.video_pks).to eq [video1.id, video.id]
            expect(coach2.video_pks).to eq [video.id]

            expect(video.coach_pks).to eq [coach1.id, coach2.id]
          end
        end
      end

      delete 'Destroy video' do
        let!(:video) { create(:video) }
        let(:id) { video.id }

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
