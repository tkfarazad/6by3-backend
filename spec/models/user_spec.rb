# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'instance methods' do
    let(:user) { create(:user) }

    it '.full_name' do
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end
end
