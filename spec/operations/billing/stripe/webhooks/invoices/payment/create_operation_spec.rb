# frozen_string_literal: true

RSpec.describe Billing::Stripe::Webhooks::Invoices::Payment::CreateOperation, :stripe do
  subject(:monthly_payment) do
    described_class.new.call(event, user)
  end

  subject(:annual_payment) do
    described_class.new.call(event, user)
  end

  let(:event) do
    StripeMock.mock_webhook_event(
      'invoice.payment_succeeded',
      lines: {
        data: [{
          plan: {
            amount: 100,
            interval: interval
          }
        }]
      }
    )
  end
  let(:plan_data) { event.data.object }
  let(:plan) { create(:stripe_plan, stripe_id: plan_data.id) }
  let!(:user) { create(:user, stripe_customer_id: plan_data.id) }

  context 'when customer invoice paid' do
    describe 'for the first time' do
      context 'monthly payment' do
        let(:interval) { 'month' }

        it 'sends monthly admin mail' do
          expect(monthly_payment.subject).to eq('Monthly subscription fee successfully charged')
          expect(monthly_payment.to).to eq(['support@6by3studio.com'])
          expect(monthly_payment.body.encoded).to include(user.full_name)
          expect(monthly_payment.body.encoded).to include(user.email)
          expect(monthly_payment.body.encoded).to include('1.0')
          expect(monthly_payment.body.encoded).to include('month')
        end
      end

      context 'annual payment' do
        let(:interval) { 'year' }

        it 'sends annual admin mail' do
          expect(annual_payment.subject).to eq('Annual subscription fee successfully charged')
          expect(annual_payment.to).to eq(['support@6by3studio.com'])
          expect(annual_payment.body.encoded).to include(user.full_name)
          expect(annual_payment.body.encoded).to include(user.email)
          expect(annual_payment.body.encoded).to include('1.0')
          expect(annual_payment.body.encoded).to include('annual')
        end
      end
    end
  end
end
