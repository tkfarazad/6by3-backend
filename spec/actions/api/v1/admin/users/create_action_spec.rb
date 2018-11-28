# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Users::CreateAction do
  let!(:user) { create(:user, :admin) }
  let(:request) { FFaker::Internet.request }
  let(:action) { described_class.new(context: {current_user: user, request: request}) }

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
          password_confirmation: password_confirmation
        }
      )
    end
    let(:email) { FFaker::Internet.email }
    let(:first_name) { FFaker::Name.first_name }
    let(:last_name) { FFaker::Name.last_name }
    let(:password) { FFaker::Internet.password }
    let(:password_confirmation) { password }

    it 'creates user' do
      expect { call }.to change(User, :count).by(1)
      expect(call).to be_success
      expect(call.success.created_in).to eq(User::USERS_CREATED_IN_ADMIN_TYPE)
    end

    context 'when params are invalid' do
      let(:input) do
        jsonapi_params(type: 'users', attributes: {})
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
        expect(call).to be_failure
        expect(call.failure).to be_kind_of(Sequel::UniqueConstraintViolation)
      end
    end
  end
end
