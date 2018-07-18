# frozen_string_literal: true

RSpec.describe VideosFinder do
  let!(:video1) { create(:video, name: 'aaa_aaa.mp4') }
  let!(:video2) { create(:video, name: 'aaa_aaa.mp4') }
  let!(:video3) { create(:video, name: 'bbb_abb.mp4') }
  let!(:video4) { create(:video, name: 'bbb_abb.mp4') }

  def find(params: {})
    described_class.new(
      initial_scope: Video.dataset
    ).call(filter: params[:filter], sort: params[:sort], paginate: params[:page]).all
  end

  context 'without filtering' do
    context 'without ordering' do
      it 'returns all records' do
        expect(find).to match_array [video1, video2, video3, video4]
      end
    end

    context 'with ordering' do
      it 'returns proper records' do
        expect(find(params: {sort: 'created_at'})).to match_array [video1, video2, video3, video4]
        expect(find(params: {sort: '-created_at'})).to match_array [video4, video3, video2, video1]
      end
    end
  end

  context 'with filtering' do
    context 'without ordering' do
      it 'returns proper records' do
        expect(find(params: {filter: {name: 'aaa_aaa.mp4'}})).to match_array [video1, video2]
        expect(find(params: {filter: {name: 'bbb_abb.mp4'}})).to match_array [video3, video4]
      end
    end

    context 'with ordering' do
      it 'returns proper records' do
        expect(
          find(params: {filter: {name: 'aaa_aaa.mp4'}, sort: 'created_at'})
        ).to match_array [video1, video2]

        expect(
          find(params: {filter: {name: 'aaa_aaa.mp4'}, sort: '-created_at'})
        ).to match_array [video2, video1]

        expect(
          find(params: {filter: {name: 'bbb_abb.mp4'}, sort: 'created_at'})
        ).to match_array [video3, video4]

        expect(
          find(params: {filter: {name: 'bbb_abb.mp4'}, sort: '-created_at'})
        ).to match_array [video4, video3]
      end
    end
  end
end