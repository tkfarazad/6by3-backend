# frozen_string_literal: true

RSpec.describe 'Favorite user coaches' do
  resource 'Favorite coaches' do
    route '/api/v1/user/relationships/favorite_coaches', 'Favorite coaches endpoint' do
      parameter :type, scope: :data, required: true

      with_options scope: %i[data relationships favorite_coaches] do
        parameter :data, type: :array, items: {type: :object}, method: :favorite_coaches_data, required: true
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

          let(:type) { 'users' }

          let(:favorite_coaches_data) do
            [
              {type: 'coaches', id: coach1.id},
              {type: 'coaches', id: coach2.id}
            ]
          end

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
