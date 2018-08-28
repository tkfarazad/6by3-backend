# frozen_string_literal: true

RSpec.describe SendContactUsLetterService do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(name: name, email: email, message: message)
    end

    let(:name) { FFaker::Name.name }
    let(:email) { FFaker::Internet.email }
    let(:message) { FFaker::Book.description }

    it 'sends letter' do
      expect(UserMailer).to(
        receive_message_chain(
          with: hash_including(:name, :email, :message),
          contact_us: no_args,
          deliver_later: no_args
        )
      )

      call
    end
  end
end
