# frozen_string_literal: true

RSpec.describe ActualizeUserPlanTypeJob do
  describe '.perform' do
    subject(:perform) do
      described_class.perform_now(subscription_id: subscription.id)
    end

    let(:subscription) { create(:stripe_subscription) }
    let(:service) { instance_double('ActualizeUserPlanTypeService') }

    before do
      allow(ActualizeUserPlanTypeService).to receive(:new).and_return(service)
      allow(service).to receive(:call)
    end

    it 'calls service' do
      perform

      expect(service).to have_received(:call).with(subscription: subscription)
    end
  end
end
