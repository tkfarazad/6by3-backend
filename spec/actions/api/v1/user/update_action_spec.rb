# frozen_string_literal: true

RSpec.describe Api::V1::User::UpdateAction do
  let!(:current_user) { create(:user, first_name: first_name) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  let(:first_name) { FFaker::Name.first_name }
  let(:new_first_name) { FFaker::Name.first_name }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(type: 'users', attributes: {first_name: new_first_name})
    end

    context 'when self' do
      let!(:user) { current_user }

      it 'grants access' do
        expect { call }.to change(user, :first_name).from(first_name).to(new_first_name)
      end
    end

    context 'when unknown param' do
      let!(:user) { current_user }

      let(:input) do
        jsonapi_params(type: 'users', attributes: {lorem: 'ipsum'})
      end

      it 'returns user' do
        expect(call).to be_success
        expect(call.success.id).to eq(user.id)
      end
    end
  end
end
