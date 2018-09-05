# frozen_string_literal: true

RSpec.describe Api::V1::Admin::Coaches::DestroyBulkAction do
  let!(:coach) { create(:coach) }
  let!(:current_user) { create(:user, :admin) }

  let(:action) { described_class.new(context: {current_user: current_user}) }

  describe '#call' do
    subject(:call) do
      data = {
        _jsonapi: {
          data: [input]
        }
      }.with_indifferent_access
      action.call(data)
    end

    let(:input) { {type: 'coaches', id: coach.id} }

    context 'when admin' do
      it 'grants access' do
        expect(call).to be_success

        call.success.each do |record|
          expect(record.id).to eq(coach.id)
          expect(record.deleted_at).not_to eq nil
        end
      end
    end
  end
end
