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
      expect(customer_deleted_user_mail.subject).to eq('6by3 Studio Subscription Cancelled by Administrator')
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
      expect(customer_deleted_admin_mail.to).to eq(['test@email.com'])
      expect(customer_deleted_admin_mail.body.encoded).to include(user.full_name)
    end
  end
end
