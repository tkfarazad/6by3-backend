# frozen_string_literal: true

RSpec.describe 'Favorite user coaches' do
  resource 'Favorite coaches' do
    route '/api/v1/user/relationships/favorite_coaches', 'Favorite coaches endpoint' do
      parameter :type, scope: :data, required: true

      with_options scope: %i[data relationships favorite_coaches] do
        parameter :data, type: :array, items: {type: :object}, method: :favorite_coaches_data, required: true
      end

      get 'All favorite coaches' do
        parameter :page

        with_options scope: :page do
          parameter :number, required: true
          parameter :size, required: true
        end

        context 'not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'authenticated user', :authenticated_user do
          let(:user) { authenticated_user }

          let!(:coach1) { create(:coach) }
          let!(:coach2) { create(:coach) }
          let!(:coach3) { create(:coach) }
          let!(:coach4) { create(:coach) }

          let!(:favorite_user_coach1) { create(:favorite_user_coach, user: user, coach: coach1) }
          let!(:favorite_user_coach2) { create(:favorite_user_coach, user: user, coach: coach2) }
          let!(:favorite_user_coach3) { create(:favorite_user_coach, user: user, coach: coach3) }

          context 'returns all favorite users' do
            example 'Responds with 200' do
              do_request

              expect(status).to eq(200)
              expect(response_body).to match_response_schema('v1/coaches/index')
              expect(parsed_body[:data].count).to eq 3
            end
          end

          context 'paginated' do
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
        end
      end

      post 'Create favorite coach' do
        context 'not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'authenticated user', :authenticated_user do
          let(:user) { authenticated_user }

          let!(:coach1) { create(:coach) }
          let!(:coach2) { create(:coach) }
          let!(:coach3) { create(:coach) }

          let(:type) { 'users' }

          let(:favorite_coaches_data) do
            [
              {type: 'coaches', id: coach1.id},
              {type: 'coaches', id: coach2.id}
            ]
          end

          context 'when user favorite coaches empty' do
            example 'creates users favorite coach' do
              do_request

              expect(status).to eq(201)
              expect(user.favorite_coaches.count).to eq(2)
              expect(FavoriteUserCoach.count).to eq(2)

              expect(user.favorite_coach_pks).to eq [coach1.id, coach2.id]
              expect(coach1.favorite_user_pks).to eq [user.id]
              expect(coach2.favorite_user_pks).to eq [user.id]
            end
          end

          context 'when user has favorite coaches' do
            let!(:favorite_user_coach1) { create(:favorite_user_coach, user: user, coach: coach3) }

            example 'creates users favorite coach' do
              expect(user.favorite_coaches.count).to eq(1)

              do_request

              expect(status).to eq(201)
              expect(user.reload.favorite_coaches.count).to eq(3)
              expect(FavoriteUserCoach.count).to eq(3)

              expect(user.favorite_coach_pks).to eq [coach3.id, coach1.id, coach2.id]
              expect(coach1.favorite_user_pks).to eq [user.id]
              expect(coach2.favorite_user_pks).to eq [user.id]
              expect(coach3.favorite_user_pks).to eq [user.id]
            end
          end
        end
      end

      delete 'Destroy favorite coach' do
        context 'not authenticated' do
          example 'Responds with 401' do
            do_request

            expect(status).to eq(401)
          end
        end

        context 'removes users favorite coach', :authenticated_user do
          let(:user) { authenticated_user }
          let!(:coach) { create(:coach) }
          let!(:favorite_user_coach) { create(:favorite_user_coach, user: user, coach: coach) }

          let(:favorite_coaches_data) do
            [
              {type: 'coaches', id: coach.id}
            ]
          end

          example 'Responds with 204' do
            do_request

            expect(status).to eq(204)
            expect(user.favorite_coaches.count).to eq(0)
            expect(FavoriteUserCoach.count).to eq(0)

            expect(user.favorite_coach_pks).to be_empty
            expect(coach.favorite_user_pks).to be_empty
          end
        end
      end
    end
  end
end
