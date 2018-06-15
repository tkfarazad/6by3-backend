# frozen_string_literal: true

RSpec.describe Users::DestroyOperation do
  let!(:user) { create(:user) }

  describe '#call' do
    subject { described_class.new(user).call }

    it 'user is softly deleted' do
      expect { subject }.not_to change(User, :count).from(1)
      expect(user.deleted_at).not_to eq nil
    end
  end
end
