# frozen_string_literal: true

RSpec.shared_examples_for '403 when user does not have permissions' do
  example_request 'Responds with 403' do
    expect(status).to eq(403)
  end
end
