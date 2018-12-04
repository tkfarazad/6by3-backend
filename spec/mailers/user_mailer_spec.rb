# frozen_string_literal: true

RSpec.describe UserMailer, type: :mailer do
  describe '.confirmation' do
    subject(:confirmation) do
      described_class
        .with(user_id: user.id, auth_token_id: auth_token.id)
        .confirmation
        .deliver_now
    end

    let(:user) { create(:user, :unconfirmed) }
    let(:auth_token) { create(:auth_token, user: user) }

    it 'sends email' do
      expect { confirmation }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(confirmation.subject).to eq('Welcome to 6by3! Confirm Your Email.')
      expect(confirmation.to).to eq([user.email])
      expect(confirmation.body.encoded).to include(user.email_confirmation_token)
      expect(confirmation.body.encoded).to include(Rails.configuration.site_url)
      expect(confirmation.body.encoded).to include(auth_token.token)
    end
  end

  describe '.reset_password' do
    subject(:reset_password) do
      described_class
        .with(user_id: user.id)
        .reset_password
        .deliver_now
    end

    let(:user) { create(:user, :reset_password_requested) }

    it 'sends email' do
      expect { reset_password }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(reset_password.subject).to eq('Password Reset')
      expect(reset_password.to).to eq([user.email])
      expect(reset_password.body.encoded).to include(user.reset_password_token)
      expect(reset_password.body.encoded).to include(Rails.configuration.site_url)
    end
  end

  describe '.free_user_created' do
    subject(:free_user_created) do
      described_class
        .with(email: user.email, name: user.full_name)
        .free_user_created
        .deliver_now
    end

    let(:user) { create(:user) }

    it 'sends email' do
      expect { free_user_created }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(free_user_created.subject).to eq('Your Free Account with 6by3')
      expect(free_user_created.to).to eq([user.email])
      expect(free_user_created.body.encoded).to include(user.full_name)
    end
  end

  describe '.monthly_subscription_paid' do
    subject(:monthly_subscription_paid) do
      described_class
        .with(email: user.email, name: user.first_name, price: price)
        .monthly_subscription_paid
        .deliver_now
    end

    let(:user) { create(:user) }
    let(:price) { rand(100).to_s }

    it 'sends email' do
      expect { monthly_subscription_paid }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(monthly_subscription_paid.subject).to eq('Your Monthly Purchase')
      expect(monthly_subscription_paid.to).to eq([user.email])
      expect(monthly_subscription_paid.body.encoded).to include(user.first_name)
      expect(monthly_subscription_paid.body.encoded).to include(price)
    end
  end

  describe '.annual_subscription_paid' do
    subject(:annual_subscription_paid) do
      described_class
        .with(email: user.email, name: user.first_name, price: price)
        .annual_subscription_paid
        .deliver_now
    end

    let(:user) { create(:user) }
    let(:price) { rand(100).to_s }

    it 'sends email' do
      expect { annual_subscription_paid }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(annual_subscription_paid.subject).to eq('Your Annual Purchase')
      expect(annual_subscription_paid.to).to eq([user.email])
      expect(annual_subscription_paid.body.encoded).to include(user.first_name)
      expect(annual_subscription_paid.body.encoded).to include(price)
    end
  end

  describe '.free_trial_start' do
    subject(:free_trial_start) do
      described_class
        .with(
          email: user.email,
          first_payment_date: first_payment_date,
          next_payment_date: next_payment_date
        )
        .free_trial_start
        .deliver_now
    end

    let(:user) { create(:user) }
    let(:first_payment_date) { Time.now.strftime('%B %d, %Y') }
    let(:next_payment_date) { 1.year.from_now.strftime('%B %d, %Y') }

    it 'sends email' do
      expect { free_trial_start }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(free_trial_start.subject).to eq('Enjoy your 7 day free trial')
      expect(free_trial_start.to).to eq([user.email])
      expect(free_trial_start.body.encoded).to include(first_payment_date)
      expect(free_trial_start.body.encoded).to include(next_payment_date)
    end
  end

  describe '.contact_us' do
    subject(:contact_us) do
      described_class
        .with(name: name, email: email, message: message)
        .contact_us
        .deliver_now
    end

    let(:name) { FFaker::Name.name }
    let(:email) { FFaker::Internet.email }
    let(:message) { FFaker::Book.description }

    it 'sends email' do
      expect { contact_us }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(contact_us.subject).to eq('6by3 - Contact Us')
      expect(contact_us.to).to eq(['support@6by3studio.com'])
      expect(contact_us.from).to eq([email])

      expect(contact_us.body.encoded).to include(name)
      expect(contact_us.body.encoded).to include(message)
    end
  end

  describe '.subscription_cancelled' do
    subject(:subscription_cancelled) do
      described_class
        .with(email: user.email, name: user.full_name, end_date: human_readable_end_data)
        .subscription_cancelled
        .deliver_now
    end

    let(:user) { create(:user) }
    let(:end_date) { Time.current + 1.month }
    let(:human_readable_end_data) { end_date.strftime('%B %d, %Y') }
    let(:subscription) { create(:stripe_subscription, current_period_end_at: end_date, user: user) }

    it 'sends email' do
      expect { subscription_cancelled }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(subscription_cancelled.subject).to eq('6by3 Cancellation Confirmation')
      expect(subscription_cancelled.to).to eq([user.email])
      expect(subscription_cancelled.body.encoded).to include(user.full_name)
      expect(subscription_cancelled.body.encoded).to include(human_readable_end_data)
    end
  end

  describe '.customer_deleted' do
    subject(:customer_deleted) do
      described_class
        .with(user_id: user.id, name: user.first_name)
        .customer_deleted
        .deliver_now
    end

    let(:user) { create(:user) }

    it 'sends email' do
      expect { customer_deleted }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(customer_deleted.subject).to eq('6by3 Studio Subscription Cancelled by Administrator')
      expect(customer_deleted.to).to eq([user.email])
      expect(customer_deleted.body.encoded).to include(user.first_name)
    end
  end
end
