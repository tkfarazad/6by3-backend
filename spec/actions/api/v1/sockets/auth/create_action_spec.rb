# frozen_string_literal: true

RSpec.describe Api::V1::Sockets::Auth::CreateAction do
  let!(:current_user) { create(:user) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    context 'when params are invalid' do
      let(:input) { {} }

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          socket_id: ['is missing'],
          channel_name: ['is missing', 'channel is not valid']
        )
      end
    end

    context 'when params are valid' do
      let(:input) { {socket_id: '1.1', channel_name: "private-users.#{current_user.id}"} }

      it 'creates coach' do
        expect(PusherService).to receive(:authenticate_channel).with(input)

        call
      end
    end
  end
end
