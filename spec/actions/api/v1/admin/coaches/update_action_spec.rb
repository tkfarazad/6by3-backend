# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Coaches::UpdateAction do
  let!(:current_user) { create(:user, :admin) }
  let!(:coach) { create(:coach, fullname: fullname) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  let(:fullname) { FFaker::Name.name }
  let(:new_fullname) { FFaker::Name.name }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(type: 'coaches', attributes: {fullname: new_fullname}).tap do |params|
        params[:id] = coach.id
      end
    end

    context 'when self' do
      it 'grants access' do
        expect { call }.to change { coach.reload.fullname }.from(fullname).to(new_fullname)
      end
    end

    context 'when unknown param' do
      let(:input) do
        jsonapi_params(type: 'coaches', attributes: {lorem: 'ipsum'}).tap do |params|
          params[:id] = coach.id
        end
      end

      it 'returns nil' do
        expect(call).to be_success
        expect(call.success).to be_nil
      end
    end
  end
end
