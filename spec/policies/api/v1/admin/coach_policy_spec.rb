# frozen_string_literal: true

RSpec.describe Api::V1::Admin::CoachPolicy do
  subject { described_class }

  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  permissions :index?, :show?, :update?, :destroy?, :create? do
    context 'not admin' do
      it 'denies access' do
        expect(subject).not_to permit(user, user)
      end
    end

    context 'admin' do
      it 'grants access' do
        expect(subject).to permit(admin_user, user)
      end
    end
  end
end
