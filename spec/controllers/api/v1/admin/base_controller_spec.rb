# frozen_string_literal: true

RSpec.describe Api::V1::Admin::BaseController, type: :controller do
  controller do
    def index; end

    Api::V1::Admin::BaseController.const_set(:IMPLEMENT_METHODS, [])
  end

  describe '#index' do
    context 'method is not implemented' do
      it 'raises error', :authenticated_admin do
        expect do
          get :index
        end.to raise_error(NotImplementedError, 'Api::V1::Admin::BaseController#index is not implemented')
      end
    end
  end
end
