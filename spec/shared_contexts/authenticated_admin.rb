# frozen_string_literal: true

RSpec.shared_context 'authenticated_admin' do
  let(:authenticated_admin) { create(:user, :admin) }

  before do
    token = Knock::AuthToken.new(payload: {sub: authenticated_admin.id}).token

    if respond_to?(:request)
      request.headers['Authorization'] = "Bearer #{token}"
    else
      header 'Authorization', "Bearer #{token}"
    end
  end
end
