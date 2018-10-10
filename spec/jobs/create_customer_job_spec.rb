# frozen_string_literal: true

RSpec.describe CreateCustomerJob do
  describe '.perform' do
    let(:user) { create(:user) }

    subject(:perform) do
      described_class.perform_now(user_id: user.id)
    end

    let(:create_customer_service) { instance_double('CreateCustomerService') }

    before do
      allow(CreateCustomerService).to receive(:new).and_return(create_customer_service)
    end

    it 'calls service' do
      expect(create_customer_service).to receive(:call).with(user)

      perform
    end
  end
end
