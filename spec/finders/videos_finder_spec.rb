# frozen_string_literal: true

RSpec.describe VideosFinder do
  let!(:video1) { create(:video, name: 'aaa_aaa.mp4', duration: 100) }
  let!(:video2) { create(:video, name: 'aaa_aaa.mp4', duration: 200) }
  let!(:video3) { create(:video, :deleted, name: 'bbb_abb.mp4', duration: 300) }
  let!(:video4) { create(:video, :deleted, name: 'bbb_abb.mp4', duration: 400) }

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:user4) { create(:user) }

  def find(params: {}, exclude: {})
    described_class.new(
      initial_scope: Video.dataset
    ).call(filter: params[:filter], sort: params[:sort], page: params[:page], exclude: exclude).all
  end

  context 'with exclusion' do
    it 'returns proper records' do
      expect(find(exclude: {deleted_at: ::SixByThree::Constants::VALUE_PRESENT})).to match_array [video1, video2]
    end
  end

  context 'without filtering' do
    context 'without sorting' do
      it 'returns all records' do
        expect(find).to match_array [video1, video2, video3, video4]
      end
    end

    context 'with sorting' do
      it 'by created date' do
        expect(find(params: {sort: 'created_at'})).to eq [video1, video2, video3, video4]
        expect(find(params: {sort: '-created_at'})).to eq [video4, video3, video2, video1]
      end

      it 'by name' do
        expect(find(params: {sort: 'name'})).to eq [video1, video2, video3, video4]
        expect(find(params: {sort: '-name'})).to eq [video3, video4, video1, video2]
      end

      it 'by duration' do
        expect(find(params: {sort: 'duration'})).to eq [video1, video2, video3, video4]
        expect(find(params: {sort: '-duration'})).to eq [video4, video3, video2, video1]
      end

      it 'by most_played' do
        [video1, video2, video3, video4].each { |video| create(:video_view, user: user1, video: video) }
        [video1, video2, video3].each { |video| create(:video_view, user: user2, video: video) }
        [video1, video2].each { |video| create(:video_view, user: user3, video: video) }
        [video1].each { |video| create(:video_view, user: user4, video: video) }

        [video1, video2, video3, video4].each(&:reload)

        expect(find(params: {sort: 'views_count'})).to eq [video4, video3, video2, video1]
        expect(find(params: {sort: '-views_count'})).to eq [video1, video2, video3, video4]
      end
    end
  end

  context 'with filtering' do
    context 'without sorting' do
      it 'returns proper records' do
        expect(find(params: {filter: {name: 'aaa_aaa.mp4'}})).to match_array [video1, video2]
        expect(find(params: {filter: {name: 'bbb_abb.mp4'}})).to match_array [video3, video4]
      end
    end

    context 'by duration in range' do
      it 'returns proper records' do
        expect(find(params: {filter: {duration: {from: 100, to: 200}}})).to match_array [video1, video2]
        expect(find(params: {filter: {duration: {from: 300, to: 400}}})).to match_array [video3, video4]
      end
    end

    context 'with sorting' do
      it 'returns proper records' do
        expect(
          find(params: {filter: {name: 'aaa_aaa.mp4'}, sort: 'created_at'})
        ).to eq [video1, video2]

        expect(
          find(params: {filter: {name: 'aaa_aaa.mp4'}, sort: '-created_at'})
        ).to eq [video2, video1]

        expect(
          find(params: {filter: {name: 'bbb_abb.mp4'}, sort: 'created_at'})
        ).to eq [video3, video4]

        expect(
          find(params: {filter: {name: 'bbb_abb.mp4'}, sort: '-created_at'})
        ).to eq [video4, video3]
      end
    end
  end
end
