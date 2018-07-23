# frozen_string_literal: true

RSpec.describe DestroyUploadOperation do
  let!(:record) { create(:user) }

  describe '#call' do
    subject { described_class.new(record).call }

    it 'record is softly deleted' do
      expect { subject }.not_to change(User, :count).from(1)
      expect(record.deleted_at).not_to eq nil
    end
  end
end
