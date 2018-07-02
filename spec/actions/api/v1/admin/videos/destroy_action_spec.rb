# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Videos::DestroyAction do
  let!(:video) { create(:video) }
  let!(:current_user) { create(:user, :admin) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(id: video.id)
    end

    context 'when admin' do
      it 'grants access' do
        expect(call).to be_success
        expect(call.success.id).to eq(video.id)

        expect(call.success.deleted_at).not_to eq nil
      end
    end
  end
end
