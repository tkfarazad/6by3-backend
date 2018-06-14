# frozen_string_literal: true

RSpec.describe "App status" do
  describe 'GET /status' do
    subject(:do_request) do
      get '/status', headers: {}, params: {}
    end

    it 'returns 200' do
      do_request

      expect(response).to have_http_status(200)
    end
  end
end
