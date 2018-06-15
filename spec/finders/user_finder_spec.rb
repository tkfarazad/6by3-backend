# frozen_string_literal: true

RSpec.describe UserFinder do
  let!(:user) { create(:user) }
  let!(:current_user) { create(:user) }

  def find(params: {})
    described_class.new(current_user).call(params[:id])
  end

  context 'no params passed' do
    it 'returns current_user' do
      expect(find).to eq current_user
    end
  end

  context 'id passed' do
    it 'returns user by id' do
      expect(find(params: {id: user.id})).to eq user
    end
  end
end
