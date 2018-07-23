# frozen_string_literal: true

RSpec.describe Excludable do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user, :deleted) }

  let(:invalid_excludable_class) do
    Class.new do
      include Excludable

      def call(scope, exclusion)
        apply_exclusion(scope, exclusion)
      end
    end
  end

  let(:excludable_class) do
    invalid_excludable_class.const_set(:AVAILABLE_EXCLUSION_KEYS, %i[deleted_at].freeze)
    invalid_excludable_class
  end

  def exclude(exclude: {})
    excludable_class.new.call(User.dataset, exclude).all
  end

  context 'throws error' do
    it 'when excludable keys are not defined' do
      expect { invalid_excludable_class.new.call(User.dataset, {}) }.to raise_error(ArgumentError)
    end
  end

  context 'without exclusion' do
    it 'returns all' do
      expect(exclude).to match_array [user1, user2, user3]
    end
  end

  context 'with exclusion' do
    it 'unknown field' do
      expect(exclude(exclude: {unknown: nil})).to match_array [user1, user2, user3]
    end

    it 'known field' do
      expect(exclude(exclude: {deleted_at: ::SixByThree::Constants::VALUE_PRESENT})).to match_array [user1, user2]
    end
  end
end
