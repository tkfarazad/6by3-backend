# frozen_string_literal: true

RSpec.describe Api::V1::Users::CreateAction do
  let(:action) { described_class.new }

  describe '#call' do
    subject(:call) do
      action.call(input)
    end

    let(:input) do
      {
        _jsonapi: {
          data: {
            type: 'users',
            attributes: {
              email: email,
              password: password,
              password_confirmation: password_confirmation
            }
          }
        }
      }.with_indifferent_access
    end
    let(:email) { FFaker::Internet.email }
    let(:password) { FFaker::Internet.password }
    let(:password_confirmation) { password }

    it 'creates user' do
      expect { call }.to change(User, :count).by(1)
    end

    context 'when params are invalid' do
      let(:input) do
        {
          _jsonapi: {
            data: {
              type: 'users',
              attributes: {}
            }
          }
        }.with_indifferent_access
      end

      it 'returns failure' do
        expect(call).to be_failure
        expect(call.failure).to eq(
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
