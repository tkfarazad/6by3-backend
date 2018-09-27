# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::UpdateAction do
  let!(:current_user) { create(:user, :admin) }
  let!(:user) { create(:user, first_name: first_name, last_name: last_name) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  let(:first_name) { FFaker::Name.first_name }
  let(:new_first_name) { FFaker::Name.first_name }
  let(:last_name) { FFaker::Name.last_name }
  let(:new_last_name) { FFaker::Name.last_name }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(
        type: 'users',
        attributes: {
          first_name: new_first_name,
          last_name: new_last_name
        }
      ).tap do |params|
        params[:id] = user.id
      end
    end

    context 'when self' do
      it 'grants access' do
        expect { call }.to(
          change { user.reload.first_name }.from(first_name).to(new_first_name)
          .and(change { user.reload.last_name }.from(last_name).to(new_last_name))
        )
      end
    end

    context 'when unknown param' do
      let(:input) do
        jsonapi_params(type: 'users', attributes: {lorem: 'ipsum'}).tap do |params|
          params[:id] = user.id
        end
      end

      it 'returns user' do
        expect(call).to be_success
        expect(call.success.id).to eq(user.id)
      end
    end
  end
end
