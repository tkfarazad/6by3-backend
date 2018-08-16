# frozen_string_literal: true

RSpec.describe 'Viewed Videos endpoint' do
  resource 'Viewed Videos' do
    route '/api/v1/videos/viewed', 'Viewed Videos endpoint' do
      let!(:video1) { create(:video) }
      let!(:video2) { create(:video) }
      let!(:video3) { create(:video) }

      get 'Get all trending videos' do
        parameter :page

        with_options scope: :page do
          parameter :number, required: true
          parameter :size, required: true
        end

        it_behaves_like '401 when user is not authenticated'

        context 'user authenticated', :authenticated_user do
          let(:user) { authenticated_user }

          let!(:video_view1) { create(:video_view, user: user, video: video1) }
          let!(:video_view2) { create(:video_view, user: user, video: video2) }

          context 'returns all records' do
            example 'Responds with 200' do
              do_request

              expect(status).to eq(200)
              expect(response_body).to match_response_schema('v1/videos/index')

              expect(parsed_body[:data].count).to eq 2
              expect(parsed_body[:data][0][:id]).to eq_id video2.id
              expect(parsed_body[:data][1][:id]).to eq_id video1.id
            end
          end
        end
      end
    end
  end
end
