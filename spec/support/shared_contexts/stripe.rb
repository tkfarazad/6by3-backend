# frozen_string_literal: true

RSpec.shared_context 'stripe' do
  let(:stripe_helper) { StripeMock.create_test_helper }

  around do |example|
    StripeMock.start

    example.run

    StripeMock.stop
  end
end
