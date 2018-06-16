# frozen_string_literal: true

RSpec.describe Api::V1::User::UpdateAction do
  let!(:current_user) { create(:user, fullname: fullname) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  let(:fullname) { FFaker::Name.name }
  let(:new_fullname) { FFaker::Name.name }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(type: 'users', attributes: {fullname: new_fullname})
    end

    context 'when self' do
      let!(:user) { current_user }

      it 'grants access' do
        expect { call }.to change(user, :fullname).from(fullname).to(new_fullname)
      end
    end

    context 'when unknown param' do
      let!(:user) { current_user }

      let(:input) do
        jsonapi_params(type: 'users', attributes: {lorem: 'ipsum'})
      end

      it 'returns nil' do
        expect(call).to be_success
        expect(call.success).to be_nil
      end
    end
  end
end