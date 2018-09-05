# frozen_string_literal: true

RSpec.describe CoachesFinder do
  let!(:coach1) { create(:coach, fullname: 'Aaa Aaa') }
  let!(:coach2) { create(:coach, fullname: 'Aaa Aaa') }
  let!(:coach3) { create(:coach, :deleted, fullname: 'Aaa Bbb') }
  let!(:coach4) { create(:coach, :deleted, fullname: 'Bbb Bbb') }
  let!(:coach5) { create(:coach, :deleted, fullname: 'Bbb Bbb') }

  def find(params: {}, exclude: {})
    described_class.new(
      initial_scope: Coach.dataset
    ).call(filter: params[:filter], sort: params[:sort], page: params[:page], exclude: exclude).all
  end

  context 'with exclusion' do
    it 'returns proper records' do
      expect(find(exclude: {deleted_at: ::SixByThree::Constants::VALUE_PRESENT})).to match_array [coach1, coach2]
    end
  end

  context 'without filtering' do
    context 'without sorting' do
      it 'returns all records' do
        expect(find).to match_array [coach1, coach2, coach3, coach4, coach5]
      end
    end

    context 'with sorting' do
      it 'by created date' do
        expect(find(params: {sort: 'created_at'})).to eq [coach1, coach2, coach3, coach4, coach5]
        expect(find(params: {sort: '-created_at'})).to eq [coach5, coach4, coach3, coach2, coach1]
      end

      it 'by fullname' do
        expect(find(params: {sort: 'fullname'})).to eq [coach1, coach2, coach3, coach4, coach5]
        expect(find(params: {sort: '-fullname'})).to eq [coach4, coach5, coach3, coach1, coach2]
      end
    end
  end

  context 'with filtering' do
    context 'without sorting' do
      it 'returns proper records' do
        expect(find(params: {filter: {fullname: 'Aaa Aaa'}})).to match_array [coach1, coach2]
        expect(find(params: {filter: {fullname: 'Aaa'}})).to match_array [coach1, coach2, coach3]
        expect(find(params: {filter: {fullname: 'Bbb Bbb'}})).to match_array [coach4, coach5]
        expect(find(params: {filter: {fullname: 'Bbb'}})).to match_array [coach3, coach4, coach5]
      end
    end

    context 'with sorting' do
      it 'returns proper records' do
        expect(
          find(params: {filter: {fullname: 'Aaa Aaa'}, sort: 'created_at'})
        ).to eq [coach1, coach2]

        expect(
          find(params: {filter: {fullname: 'Aaa Aaa'}, sort: '-created_at'})
        ).to eq [coach2, coach1]

        expect(
          find(params: {filter: {fullname: 'Bbb Bbb'}, sort: 'created_at'})
        ).to eq [coach4, coach5]

        expect(
          find(params: {filter: {fullname: 'Bbb Bbb'}, sort: '-created_at'})
        ).to eq [coach5, coach4]

        expect(
          find(params: {filter: {fullname: 'Bbb'}, sort: '-created_at'})
        ).to eq [coach5, coach4, coach3]

        expect(
          find(params: {filter: {fullname: 'Aaa'}, sort: '-created_at'})
        ).to eq [coach3, coach2, coach1]
      end
    end
  end
end
