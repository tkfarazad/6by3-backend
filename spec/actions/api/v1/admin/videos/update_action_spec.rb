# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Videos::UpdateAction do
  let!(:current_user) { create(:user, :admin) }
  let!(:video) { create(:video, name: name) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  let(:name) { FFaker::Video.name }
  let(:new_name) { FFaker::Video.name }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(type: 'videos', attributes: {name: new_name}).tap do |params|
        params[:id] = video.id
      end
    end

    context 'when self' do
      it 'grants access' do
        expect { call }.to change { video.reload.name }.from(name).to(new_name)
      end
    end

    context 'when uparam' do
      let(:input) do
        jsonapi_params(type: 'videos', attributes: {lorem: 'ipsum'}).tap do |params|
          params[:id] = video.id
        end
      end

      it 'returns nil' do
        expect(call).to be_success
        expect(call.success).to be_nil
      end
    end
  end
end
