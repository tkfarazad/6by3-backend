# frozen_string_literal: true

RSpec.describe Customerio::IdentifyUsersJob do
  describe '.perform' do
    subject(:perform) do
      described_class.perform_now
    end

    before do
      create_list(:user, 2)
    end

    it 'calls service' do
      expect(Customerio::IdentifyUserJob).to receive(:perform_later).twice

      perform
    end
  end
end
