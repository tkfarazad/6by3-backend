# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Videos::CreateAction do
  let!(:current_user) { create(:user, :admin) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(
        type: 'videos',
        attributes: {
          url: url,
          name: name,
          content_type: content_type,
          description: description
        }
      )
    end

    let(:url) { 'http://127.0.0.1:3000/video.mp4' }
    let(:name) { FFaker::Video.name }
    let(:content_type) { ::SixByThree::Constants::AVAILABLE_UPLOAD_VIDEO_CONTENT_TYPES.sample }
    let(:description) { FFaker::Book.description }

    it 'creates video' do
      expect { call }.to change(Video, :count).by(1)
    end

    context 'when params are invalid' do
      let(:input) do
        jsonapi_params(type: 'users', attributes: {})
      end

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          name: ['is missing'],
          description: ['is missing'],
          url: ['is missing'],
          content_type: ['is missing', 'incorrect video content type']
        )
      end
    end
  end
end
