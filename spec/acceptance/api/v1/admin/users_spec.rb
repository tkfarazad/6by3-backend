# frozen_string_literal: true

RSpec.describe 'Users' do
  resource 'Admin users' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user, :deleted) } # NOTE: Deleted records are not returned by default

    route '/api/v1/admin/users', 'Admin Users endpoint' do
      get 'All users' do
        parameter :page
        parameter :sort
        parameter :filter

        with_options scope: :page do
          parameter :number, required: true
          parameter :size, required: true
        end

        with_options scope: :filter do
          parameter :email
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

            expect(response_body).to match_response_schema('v1/users/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'paginated', :authenticated_admin do
          let(:number) { 2 }
          let(:size) { 1 }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/users/index')
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

            expect(response_body).to match_response_schema('v1/users/index')
            expect(parsed_body[:data].count).to eq 3
          end
        end

        context 'filtered', :authenticated_admin do
          let(:email) { user1.email }

          example 'Responds with 200' do
            do_request

            expect(response_body).to match_response_schema('v1/users/index')
            expect(parsed_body[:data].count).to eq 1
          end
        end
      end

      post 'Create user' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :email, required: true
          parameter :password, required: true
          parameter :passwordConfirmation, required: true
        end

        let(:type) { 'users' }
        let(:email) { FFaker::Internet.email }
        let(:password) { FFaker::Internet.password }
        let(:passwordConfirmation) { password }

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

            expect(response_body).to match_response_schema('v1/users/index')
            expect(parsed_body[:data][:attributes][:email]).to eq email
          end
        end

        context 'when params are invalid', :authenticated_admin do
          let(:password) { nil }

          example 'Responds with 422' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to match_response_schema('v1/error')
          end
        end

        context 'when user already exists', :authenticated_admin do
          before do
            create(:user, email: email)
          end

          example 'Responds with 409' do
            do_request

            expect(status).to eq(409)
          end
        end
      end
    end

    route '/api/v1/admin/users/:id', 'Admin User endpoint' do
      get 'Single user' do
        let!(:user) { create(:user) }
        let(:id) { user.id }

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

        context 'user was not found', :authenticated_admin do
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
            expect(response_body).to match_response_schema('v1/user')
          end
        end
      end

      put 'Update user' do
        parameter :type, scope: :data, required: true

        with_options scope: %i[data attributes] do
          parameter :fullname
        end

        let(:type) { 'users' }

        let!(:user) { create(:user) }
        let(:id) { user.id }

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
            expect(response_body).to match_response_schema('v1/user')
          end
        end
      end

      delete 'Destroy user' do
        let!(:user) { create(:user) }
        let(:id) { user.id }

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
