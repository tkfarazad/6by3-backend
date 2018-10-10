# frozen_string_literal: true

RSpec.describe Api::V1::PaymentSources::CreateAction, :stripe do
  let(:stripe_customer) { Stripe::Customer.create }
  let(:current_user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(
        attributes: {
          token: token
        }
      )
    end

    let(:token) { stripe_helper.generate_card_token }

    it 'returns success' do
      expect(call).to be_success
    end

    context 'when params are invalid' do
      let(:input) { {} }

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(token: ['is missing'])
      end
    end
  end
end
