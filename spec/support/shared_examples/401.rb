# frozen_string_literal: true

RSpec.shared_examples_for '401 when user is not authenticated' do
  example_request 'Responds with 401' do
    expect(status).to eq(401)
  end
end
