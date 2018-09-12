# frozen_string_literal: true

RSpec.describe UsersFinder do
  let!(:user1) { create(:user, fullname: 'Aaa Aaa', email: 'ccc@gmail.com', plan_type: 'trial') }
  let!(:user2) { create(:user, fullname: 'Aaa Aaa', email: 'eee@gmail.com', plan_type: 'free') }
  let!(:user3) { create(:user, fullname: 'Aaa Bbb', email: 'xxx@gmail.com', plan_type: 'trial') }
  let!(:user4) { create(:user, :deleted, fullname: 'Bbb Bbb', email: 'bbb@gmail.com', plan_type: 'paid') }
  let!(:user5) { create(:user, :deleted, fullname: 'Bbb Bbb', email: 'ddd@gmail.com', plan_type: 'free') }
  let!(:user6) { create(:user, :deleted, fullname: 'Bbb Bbb', email: 'aaa@gmail.com', plan_type: 'paid') }

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

      it 'by fullname' do
        expect(find(params: {sort: 'fullname'})).to eq [user1, user2, user3, user4, user5, user6]
        expect(find(params: {sort: '-fullname'})).to eq [user4, user5, user6, user3, user1, user2]
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
        expect(find(params: {filter: {fullname: 'Aaa'}})).to match_array [user1, user2, user3]
        expect(find(params: {filter: {fullname: 'Bbb'}})).to match_array [user3, user4, user5, user6]
        expect(find(params: {filter: {fullname: 'Aaa Aaa'}})).to match_array [user1, user2]
        expect(find(params: {filter: {fullname: 'Bbb Bbb'}})).to match_array [user4, user5, user6]
        expect(find(params: {filter: {email: user1.email}})).to match_array [user1]
      end

      it 'supports multiple querying strategies' do
        expect(find(params: {filter: {fullname: {eq: 'Bbb Bbb'}}})).to match_array [user4, user5, user6]
      end
    end

    context 'with sorting' do
      it 'returns proper records' do
        expect(
          find(params: {filter: {fullname: 'Aaa Aaa'}, sort: 'created_at'})
        ).to eq [user1, user2]

        expect(
          find(params: {filter: {fullname: 'Aaa Aaa'}, sort: '-created_at'})
        ).to eq [user2, user1]

        expect(
          find(params: {filter: {fullname: 'Bbb Bbb'}, sort: 'created_at'})
        ).to eq [user4, user5, user6]

        expect(
          find(params: {filter: {fullname: 'Bbb Bbb'}, sort: '-created_at'})
        ).to eq [user6, user5, user4]

        expect(
          find(params: {filter: {fullname: 'Bbb'}, sort: '-created_at'})
        ).to eq [user6, user5, user4, user3]
      end
    end
  end
end
