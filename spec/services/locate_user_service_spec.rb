# frozen_string_literal: true

RSpec.describe LocateUserService do
  let!(:user) { create(:user) }
  let(:ip_addr) { FFaker::Internet.ip_v4_address }
  let(:city) { FFaker::Internet.ip_v4_city }
  let(:country) { FFaker::Internet.ip_v4_country }

  describe '#call' do
    subject(:call) do
      described_class.new.call(user, ip_addr)
    end

    it 'sets user location' do
      expect { call }.to(
        change { user.city }.to(city)
        .and(change { user.country }.to(country))
      )
    end
  end
end
