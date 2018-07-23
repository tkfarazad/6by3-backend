# frozen_string_literal: true

RSpec.describe UpdateEntityOperation do
  let(:initial_data) { FFaker::Name.name }
  let!(:record) { create(:user, fullname: initial_data) }

  describe '#call' do
    subject { described_class.new(record).call(input) }

    context 'params valid' do
      let(:updated_data) { FFaker::Name.name }
      let(:input) { {fullname: updated_data} }

      it 'record is updated' do
        expect { subject }.to change(record, :fullname).from(initial_data).to(updated_data)
        expect(record.updated_at).not_to eq(record.created_at)
      end
    end
  end
end
