# frozen_string_literal: true

RSpec.shared_context 'customerio' do
  let(:customerio_client) { instance_double('Customerio::Client') }

  before do
    Container.stub('customerio.client', customerio_client)
  end
end
