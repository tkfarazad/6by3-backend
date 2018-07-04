# frozen_string_literal: true

RSpec.describe 'Videos' do
  resource 'Admin videos' do
    let!(:video1) { create(:video) }
    let!(:video2) { create(:video) }
    let!(:coaches_video1) { create(:coaches_video) }
    let!(:coaches_video2) { create(:coaches_video) }

    route '/api/v1/admin/videos', 'Admin Videos endpoint' do
      get 'All videos' do
        parameter :page
        parameter :sort
        parameter :filter
        parameter :include

        with_options scope: :page do
          parameter :number, required: true
          parameter :size, required: true
        end

        with_options scope: :filter do
          parameter :name
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
            expect(parsed_body[:data].count).to eq 4
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
              page_count: 4,
              record_count: 4
            )
          end
        end

        context 'sorted', :authenticated_admin do
          let(:sort) { '-created_at' }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 4
          end
        end

        context 'filtered', :authenticated_admin do
          let(:name) { video1.name }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/videos/index')
            expect(parsed_body[:data].count).to eq 1
          end
        end
      end

      post 'Create video' do
        let(:raw_post) { params }
        let(:name) { 'safdgsfhjg' }
        let(:content) { fixture_file_upload('spec/fixtures/files/video.mp4', 'video/mpeg') }

        parameter :content, required: true
        parameter :name, required: true

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

          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(response_body).to match_response_schema('v1/video')
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
