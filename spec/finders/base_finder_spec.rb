# frozen_string_literal: true

class DummyClass < BaseFinder
  include Sortable
  include Filterable
  include Paginatable

  AVAILABLE_FILTERING_KEYS = %i[fullname].freeze
  AVAILABLE_SORTING_KEYS = %w[fullname -fullname email -email created_at -created_at].freeze

  def filter_by(scope:, field:, value:)
    scope.where("#{field}": value)
  end
end

RSpec.describe BaseFinder do
  let!(:user1) { create(:user, fullname: 'Aaa Aaa', email: 'ccc@gmail.com') }
  let!(:user2) { create(:user, fullname: 'Aaa Aaa', email: 'eee@gmail.com') }
  let!(:user3) { create(:user, fullname: 'Bbb Bbb', email: 'bbb@gmail.com') }
  let!(:user4) { create(:user, fullname: 'Bbb Bbb', email: 'ddd@gmail.com') }
  let!(:user5) { create(:user, fullname: 'Bbb Bbb', email: 'aaa@gmail.com') }

  def find(params: {})
    DummyClass.new(
      initial_scope: User.dataset
    ).call(filter: params[:filter], sort: params[:sort], paginate: params[:page]).all
  end

  context 'configuring finder options' do
    context 'sort' do
      it 'can be configured' do
        expect(
          find(params: { sort: nil })
        ).to match_array [user1, user2, user3, user4, user5]

        expect(
          find(params: { sort: 'email' })
        ).to eq [user5, user3, user1, user4, user2]
      end
    end

    context 'filter' do
      it 'can be configured' do
        expect(
          find(params: { filter: nil })
        ).to match_array [user1, user2, user3, user4, user5]

        expect(
          find(params: { filter: { fullname: 'Aaa Aaa' }})
        ).to match_array [user1, user2]
      end
    end

    context 'paginate' do
      it 'can be configured' do
        expect(
          find(params: { page: nil })
        ).to match_array [user1, user2, user3, user4, user5]

        expect(
          find(params: { page: { number: 1, size: 2 } })
        ).to match_array [user1, user2]
      end
    end
  end

  context 'without filtering' do
    context 'without ordering' do
      it 'returns all records' do
        expect(find).to match_array [user1, user2, user3, user4, user5]
      end
    end

    context 'with asc ordering' do
      it 'returns proper records' do
        expect(find(params: { sort: 'email' })).to eq [user5, user3, user1, user4, user2]
        expect(find(params: { sort: 'created_at' })).to eq [user1, user2, user3, user4, user5]
      end
    end

    context 'with desc ordering' do
      it 'returns proper records' do
        expect(find(params: { sort: '-email' })).to eq [user2, user4, user1, user3, user5]
        expect(find(params: { sort: '-created_at' })).to eq [user5, user4, user3, user2, user1]
      end
    end
  end

  context 'with filtering' do
    context 'without ordering' do
      it 'returns proper records' do
        expect(find(params: { filter: { fullname: 'Aaa Aaa' }})).to match_array [user1, user2]
        expect(find(params: { filter: { fullname: 'Bbb Bbb' }})).to match_array [user3, user4, user5]
      end
    end

    context 'with asc ordering' do
      it 'returns proper records' do
        expect(find(params: { filter: { fullname: 'Aaa Aaa' }, sort: 'created_at' })).to eq [user1, user2]
        expect(find(params: { filter: { fullname: 'Bbb Bbb' }, sort: 'email' })).to eq [user5, user3, user4]
      end
    end

    context 'with desc ordering' do
      it 'returns proper records' do
        expect(find(params: { filter: { fullname: 'Aaa Aaa' }, sort: '-created_at' })).to eq [user2, user1]
        expect(find(params: { filter: { fullname: 'Bbb Bbb' }, sort: '-email' })).to eq [user4, user3, user5]
      end
    end
  end
end
