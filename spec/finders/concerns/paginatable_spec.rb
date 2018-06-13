# frozen_string_literal: true

RSpec.describe Paginatable do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  let(:paginatable_class) do
    Class.new do
      include Paginatable

      def call(scope, page)
        apply_pagination(scope, page)
      end
    end
  end

  def find(page: {})
    paginatable_class.new.call(User.dataset, page).all
  end

  context 'with params' do
    it 'all records' do
      expect(find(page: { number: 1, size: 2 })).to match_array [user1, user2]
    end

    it 'one record per page first page' do
      expect(find(page: { number: 1, size: 1 })).to match_array [user1]
    end

    it 'one record per page last page' do
      expect(find(page: { number: 2, size: 1 })).to match_array [user2]
    end
  end
end
