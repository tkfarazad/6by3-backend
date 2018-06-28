# frozen_string_literal: true

RSpec.describe 'Coach Avatar' do
  resource 'Coach avatar endpoint' do
    route '/api/v1/admin/coaches/:id/avatar', 'Coach avatar' do
      let!(:coach) { create(:coach) }
      let(:id) { coach.id }

      post 'Create Avatar' do
        let(:raw_post) { params }
        let(:avatar) { fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png') }

        parameter :avatar, required: true

        context 'coach avatar is created', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(parsed_body[:data][:type]).to eq 'coaches'
            expect(response_body).to match_response_schema('v1/coach')
          end
        end
      end

      put 'Update Avatar' do
        let(:raw_post) { params }
        let(:avatar) { fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png') }

        parameter :avatar, required: true

        context 'coach avatar is update', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(parsed_body[:data][:type]).to eq 'coaches'
            expect(response_body).to match_response_schema('v1/coach')
          end
        end
      end

      delete 'Destroy Avatar' do
        context 'coach avatar is destroyed(removed)', :authenticated_admin do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
            expect(parsed_body[:data][:type]).to eq 'coaches'
            expect(response_body).to match_response_schema('v1/coach')
            expect(coach.avatar.present?).to be_falsey
          end
        end
      end
    end
  end
end
