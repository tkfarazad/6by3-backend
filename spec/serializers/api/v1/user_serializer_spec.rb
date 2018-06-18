# frozen_string_literal: true

RSpec.describe Api::V1::UserSerializer, type: :serializer do
  let(:user) { build_stubbed(:user) }

  subject(:result) { serialize_entity(user, class: {User: described_class}) }

  describe 'type' do
    it 'returns proper type' do
      expect(result.dig(:data, :type)).to eq :users
    end
  end

  describe 'attributes' do
    context 'when user is not current user' do
      context 'when current user is not admin' do
        it 'returns proper attributes' do
          expect(result.dig(:data, :attributes).keys).to match_array(
            %i[
              email
            ]
          )
        end
      end

      context 'when current user is admin' do
        let(:admin) { create(:user, :admin) }
        subject(:result) { serialize_entity(user, class: {User: described_class}, expose: {current_user: admin}) }

        it 'returns proper attributes' do
          expect(result.dig(:data, :attributes).keys).to match_array(
            %i[
              email
              admin
            ]
          )
        end
      end
    end

    context 'when user is current_user' do
      subject(:result) { serialize_entity(user, class: {User: described_class}, expose: {current_user: user}) }

      it 'returns proper attributes' do
        expect(result.dig(:data, :attributes).keys).to match_array(
          %i[
            email
            admin
          ]
        )
      end
    end
  end
end
