# frozen_string_literal: true

RSpec.describe Coaches::DestroyOperation do
  let!(:coach) { create(:coach) }

  describe '#call' do
    subject { described_class.new(coach).call }

    it 'coach is softly deleted' do
      expect { subject }.not_to change(Coach, :count).from(1)
      expect(coach.deleted_at).not_to eq nil
    end
  end
end
