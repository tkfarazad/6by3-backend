# frozen_string_literal: true

RSpec.describe JsonHashColumn do
  let!(:coach) { create(:coach, social_links: {facebook: 'facebook.com'}) }

  context 'social_links' do
    it 'updates' do
      coach.set(social_links: {facebook: 'new_facebook.com'})

      expect(coach.social_links).to eq('facebook' => 'new_facebook.com')
    end

    it 'merges' do
      coach.set(social_links: {twitter: 'twitter.com'})

      expect(coach.social_links).to eq('twitter' => 'twitter.com', 'facebook' => 'facebook.com')
    end
  end
end
