# frozen_string_literal: true

RSpec.describe CoachesFinder do
  let!(:coach1) { create(:coach, fullname: 'Aaa Aaa') }
  let!(:coach2) { create(:coach, fullname: 'Aaa Aaa') }
  let!(:coach3) { create(:coach, fullname: 'Bbb Bbb') }
  let!(:coach4) { create(:coach, fullname: 'Bbb Bbb') }

  def find(params: {})
    described_class.new(
      initial_scope: Coach.dataset
    ).call(filter: params[:filter], paginate: params[:page]).all
  end

  context 'without filtering' do
    context 'without ordering' do
      it 'returns all records' do
        expect(find).to match_array [coach1, coach2, coach3, coach4]
      end
    end

    context 'with ordering' do
      it 'returns proper records' do
        expect(find(params: {sort: 'created_at'})).to match_array [coach1, coach2, coach3, coach4]
        expect(find(params: {sort: '-created_at'})).to match_array [coach4, coach3, coach2, coach1]
      end
    end
  end

  context 'with filtering' do
    context 'without ordering' do
      it 'returns proper records' do
        expect(find(params: {filter: {fullname: 'Aaa Aaa'}})).to match_array [coach1, coach2]
        expect(find(params: {filter: {fullname: 'Bbb Bbb'}})).to match_array [coach3, coach4]
      end
    end

    context 'with ordering' do
      it 'returns proper records' do
        expect(
          find(params: {filter: {fullname: 'Aaa Aaa'}, sort: 'created_at'})
        ).to match_array [coach1, coach2]

        expect(
          find(params: {filter: {fullname: 'Aaa Aaa'}, sort: '-created_at'})
        ).to match_array [coach2, coach1]

        expect(
          find(params: {filter: {fullname: 'Bbb Bbb'}, sort: 'created_at'})
        ).to match_array [coach3, coach4]

        expect(
          find(params: {filter: {fullname: 'Bbb Bbb'}, sort: '-created_at'})
        ).to match_array [coach4, coach3]
      end
    end
  end
end
