# frozen_string_literal: true

RSpec.describe AdminMailer, type: :mailer do
  describe '.customer_deleted_user_mail' do
    subject(:customer_deleted_user_mail) do
      described_class
        .with(user_id: user.id, name: user.first_name)
        .customer_deleted_user_mail
        .deliver_now
    end

    let(:user) { create(:user) }

    it 'sends email' do
      expect { customer_deleted_user_mail }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(customer_deleted_user_mail.subject).to eq('6by3 Subscription Cancelled by Admin')
      expect(customer_deleted_user_mail.to).to eq([user.email])
      expect(customer_deleted_user_mail.body.encoded).to include(user.first_name)
    end
  end

  describe '.customer_deleted_admin_mail' do
    subject(:customer_deleted_admin_mail) do
      described_class
        .with(user_id: user.id, name: user.full_name)
        .customer_deleted_admin_mail
        .deliver_now
    end

    let(:user) { create(:user) }

    it 'sends email' do
      expect { customer_deleted_admin_mail }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(customer_deleted_admin_mail.subject).to eq('6by3 Subscription Cancelled by Admin')
      expect(customer_deleted_admin_mail.to).to eq(['support@6by3studio.com'])
      expect(customer_deleted_admin_mail.body.encoded).to include(user.full_name)
    end
  end

  describe '.free_trial_user_created' do
    subject(:free_trial_user_created) do
      described_class
        .with(name: user.full_name, email: user.email)
        .free_trial_user_created
        .deliver_now
    end

    let(:user) { create(:user) }
    let(:price) { rand(100) }

    it 'sends email' do
      expect { free_trial_user_created }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(free_trial_user_created.subject).to eq('New User Registered on Free 7 Days Trial')
      expect(free_trial_user_created.to).to eq(['support@6by3studio.com'])
      expect(free_trial_user_created.body.encoded).to include(user.full_name)
      expect(free_trial_user_created.body.encoded).to include(user.email)
    end
  end

  describe '.user_first_monthly_transaction' do
    subject(:user_first_monthly_transaction) do
      described_class
        .with(name: user.full_name, email: user.email, price: price)
        .user_first_monthly_transaction
        .deliver_now
    end

    let(:user) { create(:user) }
    let(:price) { rand(100) }

    it 'sends email' do
      expect { user_first_monthly_transaction }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(user_first_monthly_transaction.subject).to eq('Monthly subscription fee successfully charged')
      expect(user_first_monthly_transaction.to).to eq(['support@6by3studio.com'])
      expect(user_first_monthly_transaction.body.encoded).to include(user.full_name)
      expect(user_first_monthly_transaction.body.encoded).to include(user.email)
      expect(user_first_monthly_transaction.body.encoded).to include(price)
    end
  end

  describe '.user_first_annual_transaction' do
    subject(:user_first_annual_transaction) do
      described_class
        .with(name: user.full_name, email: user.email, price: price)
        .user_first_annual_transaction
        .deliver_now
    end

    let(:user) { create(:user) }
    let(:price) { rand(100) }

    it 'sends email' do
      expect { user_first_annual_transaction }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(user_first_annual_transaction.subject).to eq('Annual subscription fee successfully charged')
      expect(user_first_annual_transaction.to).to eq(['support@6by3studio.com'])
      expect(user_first_annual_transaction.body.encoded).to include(user.full_name)
      expect(user_first_annual_transaction.body.encoded).to include(user.email)
      expect(user_first_annual_transaction.body.encoded).to include(price)
    end
  end

  describe '.subscription_cancelled' do
    subject(:subscription_cancelled) do
      described_class
        .with(name: user.full_name, email: user.email, price: price, subscription_type: subscription_type)
        .subscription_cancelled
        .deliver_now
    end

    let(:user) { create(:user) }
    let(:price) { rand(100) }
    let(:subscription_type) { %w(annual monthly).sample }

    it 'sends email' do
      expect { subscription_cancelled }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(subscription_cancelled.subject).to eq('Subscription Cancelled')
      expect(subscription_cancelled.to).to eq(['support@6by3studio.com'])
      expect(subscription_cancelled.body.encoded).to include(user.full_name)
      expect(subscription_cancelled.body.encoded).to include(user.email)
      expect(subscription_cancelled.body.encoded).to include(price)
      expect(subscription_cancelled.body.encoded).to include(subscription_type)
    end
  end
end
