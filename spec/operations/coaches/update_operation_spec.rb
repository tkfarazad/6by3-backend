# frozen_string_literal: true

RSpec.describe Coaches::UpdateOperation do
  let(:initial_fullname) { FFaker::Name.name }
  let!(:coach) { create(:coach, fullname: initial_fullname) }

  describe '#call' do
    subject { described_class.new(coach).call(input) }

    context 'params valid' do
      let(:new_fullname) { FFaker::Name.name }
      let(:input) { {fullname: new_fullname} }

      it 'coach is updated' do
        expect { subject }.to change(coach, :fullname).from(initial_fullname).to(new_fullname)
        expect(coach.updated_at).not_to eq(coach.created_at)
      end
    end
  end
end
