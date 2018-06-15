# frozen_string_literal: true

RSpec.describe Users::UpdateOperation do
  let!(:user) { create(:user, fullname: 'original fullname') }

  describe '#call' do
    subject { described_class.new(user).call(input) }

    context 'params valid' do
      let(:input) { {fullname: 'updated fullname'} }

      it 'user is updated' do
        expect { subject }.to change(user, :fullname).from('original fullname').to('updated fullname')
        expect(user.updated_at).not_to eq(user.created_at)
      end
    end
  end
end
