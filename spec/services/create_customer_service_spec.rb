# frozen_string_literal: true

RSpec.describe CreateCustomerService, :stripe do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(user)
    end

    let(:user) { create(:user) }

    let(:operation) { instance_double('::SC::Billing::Stripe::Customers::CreateOperation') }

    before do
      allow(::SC::Billing::Stripe::Customers::CreateOperation).to receive(:new).and_return(operation)
    end

    context 'when user has stripe_customer_id' do
      let(:stripe_customer) { Stripe::Customer.create }
      let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }

      it 'does not do anything' do
        expect(operation).not_to receive(:call)

        call
      end
    end

    context 'when user does not have stripe_customer_id' do
      let(:user) { create(:user, stripe_customer_id: nil) }

      it 'does not do anything' do
        expect(operation).to receive(:call).with(user)

        call
      end
    end
  end
end
