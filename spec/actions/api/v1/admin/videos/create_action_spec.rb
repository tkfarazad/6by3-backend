# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Videos::CreateAction do
  let!(:current_user) { create(:user, :admin) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      {
        name: name,
        content: content
      }
    end
    let(:name) { FFaker::Video.name }
    let(:content) { FFaker::Video.file }

    # it 'creates video' do
    #   # TODO: For some reason uploaded file is an instance of `Rack::Test::UploadedFile`,
    #   #       but should be `ActionDispatch::Http::UploadedFile`
    #   expect { call }.to change(Video, :count).by(1)
    # end

    context 'when params are invalid' do
      let(:input) { {} }

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          name: ['is missing'],
          content: ['is missing', ' is invalid video']
        )
      end
    end
  end
end
