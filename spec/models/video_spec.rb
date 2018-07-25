# frozen_string_literal: true

RSpec.describe Video, type: :model do
  describe 'modules' do
    it { is_expected.to include_module(::Viewable::Viewable) }
  end
end
