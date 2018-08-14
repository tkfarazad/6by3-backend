# frozen_string_literal: true

RSpec.describe Api::V1::Sockets::AuthPolicy do
  subject { described_class }

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  permissions :create? do
    context 'not current user' do
      it 'denies access' do
        expect(subject).not_to permit(user1, channel_name: "private-users.#{user2.id}")
      end
    end

    context 'is current user' do
      it 'grants access' do
        expect(subject).to permit(user1, channel_name: "private-users.#{user1.id}")
      end
    end
  end
end
