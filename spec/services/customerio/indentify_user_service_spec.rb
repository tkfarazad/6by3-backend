# frozen_string_literal: true

RSpec.describe Customerio::IdentifyUserService, :customerio do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call(user: user)
    end

    let(:user) { create(:user) }

    before do
      allow(customerio_client).to receive(:identify)
    end

    it 'identifies user in customerio' do
      call

      expect(customerio_client).to(
        have_received(:identify).with(
          hash_including(
            :id,
            :email,
            :first_name,
            :last_name,
            :created_at,
            :email_confirmed,
            :card_added,
            :plan_type,
            :cancelled
          )
        )
      )
    end

    context 'card_added attribute' do
      context 'when card is not added' do
        it 'identifies with proper value' do
          call

          expect(customerio_client).to(
            have_received(:identify).with(
              hash_including(card_added: false)
            )
          )
        end
      end

      context 'when card is added' do
        before do
          create(:stripe_payment_source, user: user)
        end

        it 'identifies with proper value' do
          call

          expect(customerio_client).to(
            have_received(:identify).with(
              hash_including(card_added: true)
            )
          )
        end
      end
    end

    context 'cancelled attribute' do
      context 'when subscription does not exist' do
        it 'identifies with proper value' do
          call

          expect(customerio_client).to(
            have_received(:identify).with(
              hash_including(cancelled: false)
            )
          )
        end
      end

      context 'when subscription is active' do
        before do
          create(:stripe_subscription, :active, user: user)
        end

        it 'identifies with proper value' do
          call

          expect(customerio_client).to(
            have_received(:identify).with(
              hash_including(cancelled: false)
            )
          )
        end
      end

      context 'when subscription is canceled' do
        before do
          create(:stripe_subscription, :canceled, user: user)
        end

        it 'identifies with proper value' do
          call

          expect(customerio_client).to(
            have_received(:identify).with(
              hash_including(cancelled: true)
            )
          )
        end
      end

      context 'when user has several subscriptions' do
        before do
          create(:stripe_subscription, :active, user: user, created_at: Time.current - 2.days)
          create(:stripe_subscription, :canceled, user: user, created_at: Time.current - 1.day)
        end

        it 'identifies with proper value' do
          call

          expect(customerio_client).to(
            have_received(:identify).with(
              hash_including(cancelled: true)
            )
          )
        end
      end
    end
  end
end
