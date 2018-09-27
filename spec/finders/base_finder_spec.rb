# frozen_string_literal: true

class DummyClass < BaseFinder
  include Sortable
  include Excludable
  include Filterable
  include Paginatable

  AVAILABLE_EXCLUSION_KEYS = %i[deleted_at].freeze
  AVAILABLE_FILTERING_KEYS = %i[first_name last_name].freeze
  AVAILABLE_SORTING_KEYS = %w[first_name -first_name last_name -last_name email -email created_at -created_at].freeze

  def filter_by(scope:, field:, value:)
    scope.where("#{field}": value)
  end
end

RSpec.describe BaseFinder do
  let!(:user1) { create(:user, first_name: 'Aa', last_name: 'Aa', email: 'ccc@gmail.com') }
  let!(:user2) { create(:user, first_name: 'Ab', last_name: 'Ab', email: 'eee@gmail.com') }
  let!(:user3) { create(:user, :deleted, first_name: 'De', last_name: 'De', email: 'bbb@gmail.com') }
  let!(:user4) { create(:user, :deleted, first_name: 'Df', last_name: 'Df', email: 'ddd@gmail.com') }
  let!(:user5) { create(:user, :deleted, first_name: 'Dg', last_name: 'Dg', email: 'aaa@gmail.com') }

  def find(params: {}, exclude: {})
    DummyClass.new(
      initial_scope: User.dataset
    ).call(filter: params[:filter], sort: params[:sort], page: params[:page], exclude: exclude).all
  end

  context 'with exclusion' do
    it 'returns proper records' do
      expect(find(exclude: {deleted_at: ::SixByThree::Constants::VALUE_PRESENT})).to match_array [user1, user2]
    end
  end

  context 'configuring finder options' do
    context 'sort' do
      it 'can be configured' do
        expect(
          find(params: {sort: nil})
        ).to match_array [user1, user2, user3, user4, user5]

        expect(
          find(params: {sort: 'email'})
        ).to eq [user5, user3, user1, user4, user2]
      end
    end

    context 'filter' do
      it 'can be configured' do
        expect(
          find(params: {filter: nil})
        ).to match_array [user1, user2, user3, user4, user5]

        expect(
          find(params: {filter: {first_name: 'A'}})
        ).to match_array [user1, user2]
      end

      it 'when case insensitive' do
        expect(
          find(params: {filter: nil})
        ).to match_array [user1, user2, user3, user4, user5]

        expect(
          find(params: {filter: {first_name: 'a'}})
        ).to match_array [user1, user2]
      end
    end

    context 'paginate' do
      it 'can be configured' do
        expect(
          find(params: {page: nil})
        ).to match_array [user1, user2, user3, user4, user5]

        expect(
          find(params: {page: {number: 1, size: 2}})
        ).to match_array [user1, user2]
      end
    end
  end

  context 'without filtering' do
    context 'without sorting' do
      it 'returns all records' do
        expect(find).to match_array [user1, user2, user3, user4, user5]
      end
    end

    context 'with asc sorting order' do
      it 'returns proper records' do
        expect(find(params: {sort: 'email'})).to eq [user5, user3, user1, user4, user2]
        expect(find(params: {sort: 'created_at'})).to eq [user1, user2, user3, user4, user5]
      end
    end

    context 'with desc sorting order' do
      it 'returns proper records' do
        expect(find(params: {sort: '-email'})).to eq [user2, user4, user1, user3, user5]
        expect(find(params: {sort: '-created_at'})).to eq [user5, user4, user3, user2, user1]
      end
    end
  end

  context 'with filtering' do
    context 'without sorting' do
      it 'returns proper records' do
        expect(find(params: {filter: {first_name: 'A'}})).to match_array [user1, user2]
        expect(find(params: {filter: {last_name: 'D'}})).to match_array [user3, user4, user5]
      end
    end

    context 'with asc sorting order' do
      it 'returns proper records' do
        expect(find(params: {filter: {first_name: 'A'}, sort: 'created_at'})).to eq [user1, user2]
        expect(find(params: {filter: {last_name: 'D'}, sort: 'email'})).to eq [user5, user3, user4]
      end
    end

    context 'with desc sorting order' do
      it 'returns proper records' do
        expect(find(params: {filter: {first_name: 'A'}, sort: '-created_at'})).to eq [user2, user1]
        expect(find(params: {filter: {last_name: 'D'}, sort: '-email'})).to eq [user4, user3, user5]
      end
    end
  end
end
