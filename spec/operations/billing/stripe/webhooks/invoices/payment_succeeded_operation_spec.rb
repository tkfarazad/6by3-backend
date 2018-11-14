# frozen_string_literal: true

RSpec.describe Billing::Stripe::Webhooks::Invoices::PaymentSucceededOperation, :stripe do
  describe '#call' do
    subject(:call) do
      described_class.new.call(invoice: invoice)
    end

    let(:invoice) { create(:stripe_invoice) }

    context 'when payment for monthly subscription' do
      before do
        plan = create(:stripe_plan, interval: 'month')
        create(:stripe_invoice_item, invoice: invoice, plan: plan)
      end

      context 'when it is the first payment' do
        before do
          create(:stripe_invoice, amount_paid: 0, paid: true) # invoice for trial
        end

        it 'sends email' do
          expect { call }.to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
              .with(
                'AdminMailer',
                'user_first_monthly_transaction',
                'deliver_now',
                hash_including(:email, :name, :price)
              )
          )
        end
      end

      context 'when it is not the first payment' do
        before do
          create(:stripe_invoice, amount_paid: 1000, paid: true, user: invoice.user)
        end

        it 'sends email' do
          expect { call }.not_to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
          )
        end
      end

      context 'when invoice is free(for trial)' do
        let(:invoice) { create(:stripe_invoice, amount_paid: 0, paid: true) }

        it 'sends email' do
          expect { call }.not_to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
          )
        end
      end
    end

    context 'when payment for annual subscription' do
      before do
        plan = create(:stripe_plan, interval: 'year')
        create(:stripe_invoice_item, invoice: invoice, plan: plan)
      end

      context 'when it is the first payment' do
        before do
          create(:stripe_invoice, amount_paid: 0, paid: true) # invoice for trial
        end

        it 'sends email' do
          expect { call }.to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
              .with(
                'AdminMailer',
                'user_first_annual_transaction',
                'deliver_now',
                hash_including(:email, :name, :price)
              )
          )
        end
      end

      context 'when it is not the first payment' do
        before do
          create(:stripe_invoice, amount_paid: 1000, paid: true, user: invoice.user)
        end

        it 'sends email' do
          expect { call }.not_to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
          )
        end
      end

      context 'when invoice is free(for trial)' do
        let(:invoice) { create(:stripe_invoice, amount_paid: 0, paid: true) }

        it 'sends email' do
          expect { call }.not_to(
            have_enqueued_job(ActionMailer::Parameterized::DeliveryJob)
          )
        end
      end
    end
  end
end