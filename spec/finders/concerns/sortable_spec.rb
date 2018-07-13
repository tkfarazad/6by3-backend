# frozen_string_literal: true

RSpec.describe Sortable do
  let!(:user1) { create(:user, fullname: 'Bbb Bbb') }
  let!(:user2) { create(:user, fullname: 'Aaa Aaa') }
  let!(:user3) { create(:user, fullname: 'Ccc Ccc') }

  let(:invalid_sortable_class) do
    Class.new do
      include Sortable

      def call(scope, sort)
        apply_sorting(scope, sort)
      end
    end
  end

  let(:sortable_class) do
    invalid_sortable_class.const_set(:AVAILABLE_SORTING_KEYS, %w[created_at -created_at fullname -fullname].freeze)
    invalid_sortable_class
  end

  def sort(sort: '')
    sortable_class.new.call(User.dataset, sort).all
  end

  context 'throws error' do
    it 'when sortable keys are not defined' do
      expect { invalid_sortable_class.new.call(User.dataset) }.to raise_error(ArgumentError)
    end
  end

  context 'without params' do
    it 'returns all' do
      expect(sort(sort: '')).to match_array [user1, user2, user3]
    end
  end

  context 'with params' do
    it 'param is unknown' do
      expect(sort(sort: 'lorem_ippsum')).to match_array [user1, user2, user3]
    end

    it 'sort by created_at' do
      expect(sort(sort: 'created_at')).to eq [user1, user2, user3]
      expect(sort(sort: '-created_at')).to eq [user3, user2, user1]
    end

    it 'sort by fullname' do
      expect(sort(sort: 'fullname')).to eq [user2, user1, user3]
      expect(sort(sort: '-fullname')).to eq [user3, user1, user2]
    end
  end

  context 'with multiple params' do
    it 'accepts multiple sort params' do
      expect(sort(sort: '-fullname,-created_at')).to eq [user3, user1, user2]
    end
  end
end
