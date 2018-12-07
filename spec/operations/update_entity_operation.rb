# frozen_string_literal: true

RSpec.describe UpdateEntityOperation do
  let(:initial_data) { FFaker::Name.name }
  let!(:record) { create(:coach, fullname: initial_data) }

  describe '#call' do
    subject { described_class.new(record).call(input) }

    context 'params valid' do
      let(:updated_data) { FFaker::Name.name }
      let(:input) { {fullname: updated_data} }

      it 'record is updated' do
        expect { subject }.to change(record, :fullname).from(initial_data).to(updated_data)
        expect(subject).to eq(record)
        expect(record.updated_at).not_to eq(record.created_at)
      end
    end

    context 'when nothing to update' do
      let(:input) { {} }

      it 'returns record' do
        expect(subject).to eq(record)
      end
    end
  end
end
