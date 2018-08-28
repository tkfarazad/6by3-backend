# frozen_string_literal: true

RSpec.describe Api::V1::ContactUsEmail::CreateAction do
  let(:action) { described_class.new }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(
        attributes: {
          name: name,
          email: email,
          message: message
        }
      )
    end
    let(:name) { FFaker::Name.name }
    let(:email) { FFaker::Internet.email }
    let(:message) { FFaker::Book.description }

    context 'when params are invalid' do
      let(:input) { {} }

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          name: ['is missing'],
          email: ['is missing', ' is invalid email'],
          message: ['is missing']
        )
      end
    end

    context 'when params valid' do
      it 'calls service' do
        expect(::SendContactUsLetterJob).to receive(:perform_later).with(name: name, email: email, message: message)

        call
      end
    end
  end
end
