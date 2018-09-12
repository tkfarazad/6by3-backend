# frozen_string_literal: true

RSpec.describe do
  resource 'Plans' do
    route '/api/v1/plans{?include}', 'Plans endpoint' do
      get 'All videos' do
        parameter :include, example: 'product'

        let(:include) { 'product' }

        it_behaves_like '401 when user is not authenticated'

        context 'authenticated user', :authenticated_user do
          before do
            create_list(:stripe_plan, 2)
          end

          example_request 'Responds with 200' do
            expect(parsed_body[:data].count).to eq 2
            expect(response_body).to match_json_schema('v1/plan_list')
          end
        end
      end
    end
  end
end
