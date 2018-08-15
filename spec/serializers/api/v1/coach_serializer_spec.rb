# frozen_string_literal: true

RSpec.describe Api::V1::CoachSerializer, type: :serializer do
  let(:coach) { build_stubbed(:coach) }

  subject(:result) { serialize_entity(coach, class: {Coach: described_class}) }

  describe 'type' do
    it 'returns proper type' do
      expect(result.dig(:data, :type)).to eq :coaches
    end
  end

  describe 'attributes' do
    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }
      subject(:result) { serialize_entity(coach, class: {Coach: described_class}, expose: {current_user: admin}) }

      it 'returns proper attributes' do
        expect(result.dig(:data, :attributes).keys).to match_array(
          %i[
            avatar
            favorited
            fullname
            deletedAt
            certifications
            personalInfo
            featured
          ]
        )
      end
    end

    context 'when user is not admin' do
      it 'returns proper attributes' do
        expect(result.dig(:data, :attributes).keys).to match_array(
          %i[
            avatar
            favorited
            fullname
            certifications
            personalInfo
            featured
          ]
        )
      end
    end
  end
end
