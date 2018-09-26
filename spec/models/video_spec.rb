# frozen_string_literal: true

RSpec.describe Video, type: :model do
  subject { create(:video) }

  describe 'modules' do
    it { is_expected.to include_module(::Viewable::Viewable) }
  end

  describe 'aasm state' do
    it 'one can_be_processed step' do
      expect(subject).to transition_from(:can_be_processed).to(:processing).on_event(:start_processing)
      expect(subject).to transition_from(:processing).to(:processed).on_event(:end_processing)
      expect(subject).to transition_from(:processed).to(:can_be_processed).on_event(:reset_state)
    end
  end
end
