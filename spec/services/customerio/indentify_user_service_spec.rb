# frozen_string_literal: true

RSpec.describe Customerio::IdentifyUserService, :stripe do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(user: user)
    end

    let(:user) { create(:user) }
    let(:customerio_client) { instance_double('Customerio::Client') }

    before do
      Container.stub('customerio.client', customerio_client)
    end

    it 'identifies user in customerio' do
      expect(customerio_client).to(
        receive(:identify).with(
          hash_including(:id, :email, :created_at, :email_confirmed, :credit_card_added)
        )
      )

      call
    end
  end
end
