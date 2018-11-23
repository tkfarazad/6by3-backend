# frozen_string_literal: true

RSpec.describe LocateUserJob do
  describe '.perform' do
    let(:user) { create(:user) }
    let(:ip_addr) { FFaker::Internet.ip_v4_address }

    subject(:perform) do
      described_class.perform_now(user_id: user.id, ip_addr: ip_addr)
    end

    it 'calls service' do
      expect_any_instance_of(LocateUserService).to receive(:call).with(user, ip_addr)

      perform
    end
  end
end
