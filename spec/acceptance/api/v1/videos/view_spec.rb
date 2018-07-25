# frozen_string_literal: true

RSpec.describe 'Video views' do
  resource 'Create video view' do
    route '/api/v1/videos/:id/view', 'Create video view' do
      post 'Create video view' do
        let!(:video) { create(:video) }
        let(:id) { video.id }

        context 'user watches video', :authenticated_user do
          example 'for the first time' do
            do_request

            expect(status).to eq(202)
            expect(User.first.video_views.count).to eq(1)
            expect(Video.first.views.count).to eq(1)
          end

          example 'which have already watched' do
            do_request

            expect(status).to eq(202)
            expect(User.first.video_views.count).to eq(1)
            expect(Video.first.views.count).to eq(1)
          end
        end
      end
    end
  end
end
