# frozen_string_literal: true

RSpec.describe UsersFinder do
  let!(:user1) { create(:user, first_name: 'Aa', last_name: 'Aa', email: 'ccc@gmail.com', plan_type: 'trial') }
  let!(:user2) { create(:user, first_name: 'Ab', last_name: 'Ab', email: 'eee@gmail.com', plan_type: 'free') }
  let!(:user3) { create(:user, first_name: 'Ac', last_name: 'Ac', email: 'xxx@gmail.com', plan_type: 'trial') }
  let!(:user4) { create(:user, :deleted, first_name: 'De', last_name: 'De', email: 'bbb@gmail.com', plan_type: 'paid') }
  let!(:user5) { create(:user, :deleted, first_name: 'Df', last_name: 'Df', email: 'ddd@gmail.com', plan_type: 'free') }
  let!(:user6) { create(:user, :deleted, first_name: 'Dg', last_name: 'Dg', email: 'aaa@gmail.com', plan_type: 'paid') }

  def find(params: {}, exclude: {})
    described_class.new(
      initial_scope: User.dataset
    ).call(filter: params[:filter], sort: params[:sort], page: params[:page], exclude: exclude).all
  end

  context 'with exclusion' do
    it 'returns proper records' do
      expect(find(exclude: {deleted_at: ::SixByThree::Constants::VALUE_PRESENT})).to match_array [user1, user2, user3]
    end
  end

  context 'without filtering' do
    context 'without sorting' do
      it 'returns all records' do
        expect(find).to match_array [user1, user2, user3, user4, user5, user6]
      end
    end

    context 'with sorting' do
      it 'by created data' do
        expect(find(params: {sort: 'created_at'})).to eq [user1, user2, user3, user4, user5, user6]
        expect(find(params: {sort: '-created_at'})).to eq [user6, user5, user4, user3, user2, user1]
      end

      it 'by email' do
        expect(find(params: {sort: 'email'})).to eq [user6, user4, user1, user5, user2, user3]
        expect(find(params: {sort: '-email'})).to eq [user3, user2, user5, user1, user4, user6]
      end

      it 'by first_name' do
        expect(find(params: {sort: 'first_name'})).to eq [user1, user2, user3, user4, user5, user6]
        expect(find(params: {sort: '-first_name'})).to eq [user6, user5, user4, user3, user2, user1]
      end

      it 'by last_name' do
        expect(find(params: {sort: 'last_name'})).to eq [user1, user2, user3, user4, user5, user6]
        expect(find(params: {sort: '-last_name'})).to eq [user6, user5, user4, user3, user2, user1]
      end

      it 'by plan_type' do
        expect(find(params: {sort: 'plan_type'})).to eq [user2, user5, user1, user3, user4, user6]
        expect(find(params: {sort: '-plan_type'})).to eq [user4, user6, user1, user3, user2, user5]
      end
    end
  end

  context 'with filtering' do
    context 'without sorting' do
      it 'returns proper records' do
        expect(find(params: {filter: {first_name: 'A'}})).to match_array [user1, user2, user3]
        expect(find(params: {filter: {last_name: 'D'}})).to match_array [user4, user5, user6]
        expect(find(params: {filter: {email: user1.email}})).to eq [user1]
      end

      it 'supports multiple querying strategies' do
        expect(find(params: {filter: {first_name: {eq: 'Ac'}}})).to match_array [user3]
      end
    end

    context 'with sorting' do
      it 'returns proper records' do
        expect(
          find(params: {filter: {first_name: 'A'}, sort: 'created_at'})
        ).to eq [user1, user2, user3]

        expect(
          find(params: {filter: {first_name: 'A'}, sort: '-created_at'})
        ).to eq [user3, user2, user1]

        expect(
          find(params: {filter: {last_name: 'D'}, sort: 'created_at'})
        ).to eq [user4, user5, user6]

        expect(
          find(params: {filter: {last_name: 'D'}, sort: '-created_at'})
        ).to eq [user6, user5, user4]
      end
    end
  end
end
