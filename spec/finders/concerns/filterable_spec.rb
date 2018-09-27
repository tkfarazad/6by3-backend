# frozen_string_literal: true

RSpec.describe Filterable do
  let!(:user1) { create(:user, first_name: 'Aaa') }
  let!(:user2) { create(:user, first_name: 'Aaa') }
  let!(:user3) { create(:user, first_name: 'Bbb') }

  let(:invalid_filterable_class) do
    Class.new do
      include Filterable

      def call(scope, filter)
        apply_filters(scope, filter)
      end

      def filter_by_ilike(scope:, field:, value:)
        scope.where(Sequel.ilike(field, "%#{value}%"))
      end

      def filter_by_eq(scope:, field:, value:)
        scope.where(field => value)
      end
    end
  end

  let(:filterable_class) do
    invalid_filterable_class.const_set(:AVAILABLE_FILTERING_KEYS, %i[email first_name].freeze)
    invalid_filterable_class.const_set(:CUSTOM_FILTERS, {}.freeze)
    invalid_filterable_class
  end

  def filter(filter: {})
    filterable_class.new.call(User.dataset, filter).all
  end

  context 'throws error' do
    it 'when filtering keys are not defined' do
      expect { invalid_filterable_class.new.call(User.dataset, {}) }.to raise_error(ArgumentError)
    end
  end

  context 'without filters' do
    it 'returns all' do
      expect(filter).to match_array [user1, user2, user3]
    end
  end

  context 'with filters' do
    it 'filter by unknown' do
      expect(filter(filter: {unknown: user1.email})).to match_array [user1, user2, user3]
    end

    it 'filter by email' do
      expect(filter(filter: {email: user1.email})).to eq [user1]
      expect(filter(filter: {email: user2.email})).to eq [user2]
      expect(filter(filter: {email: user3.email})).to eq [user3]
    end

    it 'filter by first_name with ilike' do
      expect(filter(filter: {first_name: 'aaa'})).to match_array [user1, user2]
      expect(filter(filter: {first_name: 'bbb'})).to match_array [user3]
    end
  end

  context 'with multiple filters' do
    it 'email and first_name passed' do
      expect(filter(filter: {email: user1.email, first_name: user3.first_name})).to be_empty
      expect(filter(filter: {email: user1.email, first_name: user1.first_name})).to eq [user1]
    end
  end

  context 'with different querying strategies' do
    it 'query only equals' do
      expect(filter(filter: {email: {eq: user1.email}})).to eq [user1]
      expect(filter(filter: {first_name: {eq: user2.first_name}})).to eq [user1, user2]
    end
  end
end
