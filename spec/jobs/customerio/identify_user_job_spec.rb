# frozen_string_literal: true

RSpec.describe Customerio::IdentifyUserJob do
  describe '.perform' do
    let(:user) { create(:user) }

    subject(:perform) do
      described_class.perform_now(user_id: user.id)
    end

    let(:identify_user_service) { instance_double('Customerio::IdentifyUserService') }

    before do
      allow(Customerio::IdentifyUserService).to receive(:new).and_return(identify_user_service)
    end

    it 'calls service' do
      expect(identify_user_service).to receive(:call).with(user: user)

      perform
    end
  end
end
