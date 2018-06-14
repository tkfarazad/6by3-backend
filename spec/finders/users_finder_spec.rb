# frozen_string_literal: true

RSpec.describe UsersFinder do
  let!(:user1) { create(:user, fullname: 'Aaa Aaa', email: 'ccc@gmail.com') }
  let!(:user2) { create(:user, fullname: 'Aaa Aaa', email: 'eee@gmail.com') }
  let!(:user3) { create(:user, fullname: 'Bbb Bbb', email: 'bbb@gmail.com') }
  let!(:user4) { create(:user, fullname: 'Bbb Bbb', email: 'ddd@gmail.com') }
  let!(:user5) { create(:user, fullname: 'Bbb Bbb', email: 'aaa@gmail.com') }

  def find(params: {})
    described_class.new(
      initial_scope: User.dataset
    ).call(filter: params[:filter], sort: params[:sort], paginate: params[:paginate]).all
  end

  context 'without filtering' do
    context 'without ordering' do
      it 'returns all records' do
        expect(find).to match_array [user1, user2, user3, user4, user5]
      end
    end

    context 'with ordering' do
      it 'returns proper records' do
        expect(find(params: { sort: 'created_at' })).to match_array [user1, user2, user3, user4, user5]
        expect(find(params: { sort: '-created_at' })).to match_array [user5, user4, user3, user2, user1]
      end
    end
  end

  context 'with filtering' do
    context 'without ordering' do
      it 'returns proper records' do
        expect(find(params: { filter: { fullname: 'Aaa Aaa' }})).to match_array [user1, user2]
        expect(find(params: { filter: { fullname: 'Bbb Bbb' }})).to match_array [user3, user4, user5]
        expect(find(params: { filter: { email: user1.email }})).to match_array [user1]
      end
    end

    context 'with ordering' do
      it 'returns proper records' do
        expect(
          find(params: { filter: { fullname: 'Aaa Aaa' }, sort: 'created_at' })
        ).to match_array [user1, user2]

        expect(
          find(params: { filter: { fullname: 'Aaa Aaa' }, sort: '-created_at' })
        ).to match_array [user2, user1]

        expect(
          find(params: { filter: { fullname: 'Bbb Bbb' }, sort: 'created_at' })
        ).to match_array [user3, user4, user5]

        expect(
          find(params: { filter: { fullname: 'Bbb Bbb' }, sort: '-created_at' })
        ).to match_array [user5, user4, user3]
      end
    end
  end
end