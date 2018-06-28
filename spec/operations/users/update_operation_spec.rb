# frozen_string_literal: true

RSpec.describe Users::UpdateOperation do
  let(:initial_fullname) { FFaker::Name.name }
  let!(:user) { create(:user, fullname: initial_fullname) }

  describe '#call' do
    subject { described_class.new(user).call(input) }

    context 'params valid' do
      let(:new_fullname) { FFaker::Name.name }
      let(:input) { {fullname: new_fullname} }

      it 'user is updated' do
        expect { subject }.to change(user, :fullname).from(initial_fullname).to(new_fullname)
        expect(user.updated_at).not_to eq(user.created_at)
      end
    end
  end
end
