# frozen_string_literal: true

RSpec.shared_examples_for '401 when user is not authenticated' do
  context 'when user not authenticated' do
    example 'Responds with 401' do
      do_request

      expect(status).to eq(401)
    end
  end
end
