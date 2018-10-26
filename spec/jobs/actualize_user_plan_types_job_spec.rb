# frozen_string_literal: true

RSpec.describe ActualizeUserPlanTypesJob do
  include ActiveJob::TestHelper

  describe '.perform' do
    subject(:perform) do
      described_class.perform_now
    end

    before do
      create_list(:stripe_subscription, 2)
    end

    it 'calls service' do
      expect { perform }.to have_enqueued_job(ActualizeUserPlanTypeJob).twice
    end
  end
end
