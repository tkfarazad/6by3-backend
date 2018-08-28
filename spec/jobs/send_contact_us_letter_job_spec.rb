# frozen_string_literal: true

RSpec.describe SendContactUsLetterJob do
  describe '.perform' do
    let(:name) { FFaker::Name.name }
    let(:email) { FFaker::Internet.email }
    let(:message) { FFaker::Book.description }

    subject(:perform) do
      described_class.perform_now(name: name, email: email, message: message)
    end

    it 'calls service' do
      expect_any_instance_of(
        SendContactUsLetterService
      ).to receive(:call).with(name: name, email: email, message: message)

      perform
    end
  end
end
