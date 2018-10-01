# frozen_string_literal: true

RSpec.describe Api::V1::Users::CreateAction do
  let(:action) { described_class.new }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      jsonapi_params(
        type: 'users',
        attributes: {
          email: email,
          first_name: first_name,
          last_name: last_name,
          password: password,
          passwordConfirmation: password_confirmation
        }
      )
    end
    let(:email) { FFaker::Internet.email }
    let(:first_name) { FFaker::Name.first_name }
    let(:last_name) { FFaker::Name.last_name }
    let(:password) { FFaker::Internet.password }
    let(:password_confirmation) { password }

    it 'creates user' do
      expect(SendConfirmationLetterJob).to receive(:perform_later)

      expect { call }.to change(User, :count).by(1)
    end

    context 'when params are invalid' do
      let(:input) do
        jsonapi_params(
          type: 'users',
          attributes: {}
        )
      end

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
          first_name: ['is missing'],
          last_name: ['is missing'],
          email: ['is missing', ' is invalid email'],
          password: ['is missing', 'size cannot be less than 6']
        )
      end
    end

    context 'when user with the same email already exists' do
      before do
        create(:user, email: email)
      end

      it 'return failure' do
        expect(SendConfirmationLetterJob).to_not receive(:perform_later)

        expect(call).to be_failure
        expect(call.failure).to be_kind_of(Sequel::UniqueConstraintViolation)
      end
    end

    context 'when user with the same email already exists but with empty password_digest' do
      let!(:user) { create(:user, :empty_password, email: email) }

      it 'actualizes user' do
        expect(SendConfirmationLetterJob).to receive(:perform_later)

        expect { call }.to(change { user.reload.password_digest })

        is_expected.to be_success
      end
    end
  end
end
