# frozen_string_literal: true

RSpec.describe SendCustomerDeletedLetterService do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(user)
    end

    let(:user) { create(:user) }

    it 'sends letter' do
      expect(UserMailer).to(
        receive_message_chain(
          with: hash_including(:user_id, :name),
          customer_deleted_user_mail: no_args,
          deliver_later: no_args
        )
      )

      call
    end
  end
end
