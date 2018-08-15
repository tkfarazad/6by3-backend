# frozen_string_literal: true

RSpec.describe 'Video views' do
  resource 'Video view endpoint' do
    route '/api/v1/videos/:id/view', 'Video view' do
      let!(:video1) { create(:video) }
      let(:id) { video1.id }

      post 'Create video view' do
        context 'user watches video', :authenticated_user do
          let(:user) { authenticated_user }

          # NOTE: they are both the same, but executing in order, so one of them will be working with viewed video
          example 'for the first time' do
            do_request

            expect(status).to eq(202)
            expect(user.video_views.count).to eq(1)
            expect(video1.views.count).to eq(1)
          end

          example 'which have already watched' do
            do_request

            expect(status).to eq(202)
            expect(user.video_views.count).to eq(1)
            expect(video1.views.count).to eq(1)
          end
        end
      end

      delete 'Destroy video view' do
        let(:user) { authenticated_user }
        let!(:video_view) { create(:video_view, user: user, video: video1) }

        context 'user has watched video', :authenticated_user do
          example 'responds with 204' do
            do_request

            expect(status).to eq(204)
            expect(user.video_views.count).to eq 0
            expect(video1.views.count).to eq 0
          end
        end

        context 'user has not watched video', :authenticated_user do
          let!(:video2) { create(:video) }
          let(:id) { video2.id }

          example 'responds with 204' do
            do_request

            expect(status).to eq(204)
            expect(user.video_views.count).to eq 1
            expect(video1.views.count).to eq 1
            expect(video2.views.count).to eq 0
          end
        end
      end
    end
  end
end
