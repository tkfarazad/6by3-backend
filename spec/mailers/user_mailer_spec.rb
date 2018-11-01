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
      expect(confirmation.subject).to eq('Confirm Your Email')
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
      expect(reset_password.subject).to eq('Reset password')
      expect(reset_password.to).to eq([user.email])
      expect(reset_password.body.encoded).to include(user.reset_password_token)
      expect(reset_password.body.encoded).to include(Rails.configuration.site_url)
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
end
