# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::UpdateAction do
  let!(:current_user) { create(:user, :admin) }
  let!(:user) { create(:user, fullname: fullname) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  let(:fullname) { FFaker::Name.name }
  let(:new_fullname) { FFaker::Name.name }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(type: 'users', attributes: {fullname: new_fullname}).tap do |params|
        params[:id] = user.id
      end
    end

    context 'when self' do
      it 'grants access' do
        expect { call }.to change { user.reload.fullname }.from(fullname).to(new_fullname)
      end
    end

    context 'when unknown param' do
      let(:input) do
        jsonapi_params(type: 'users', attributes: {lorem: 'ipsum'}).tap do |params|
          params[:id] = user.id
        end
      end

      it 'returns nil' do
        expect(call).to be_success
        expect(call.success).to be_nil
      end
    end
  end
end
