# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Coaches::CreateAction do
  let!(:current_user) { create(:user, :admin) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(
        type: 'coaches',
        attributes: {
          fullname: fullname
        }
      )
    end
    let(:fullname) { FFaker::Name.name }

    it 'creates coach' do
      expect { call }.to change(Coach, :count).by(1)
    end

    context 'when params are invalid' do
      let(:input) do
        jsonapi_params(type: 'coaches', attributes: {})
      end

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          fullname: ['is missing']
        )
      end
    end
  end
end
