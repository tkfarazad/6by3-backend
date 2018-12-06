# frozen_string_literal: true

RSpec.describe Customerio::IdentifyUserService, :customerio do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(user: user)
    end

    let(:user) { create(:user) }

    it 'identifies user in customerio' do
      allow(customerio_client).to receive(:identify)

      call

      expect(customerio_client).to(
        have_received(:identify).with(
          hash_including(
            :id,
            :email,
            :first_name,
            :last_name,
            :created_at,
            :email_confirmed,
            :card_added
          )
        )
      )
    end
  end
end
