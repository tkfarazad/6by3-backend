# frozen_string_literal: true

RSpec.shared_context 'authenticated_user' do
  let(:authenticated_user) { create(:user) }

  before do
    token = Knock::AuthToken.new(payload: {sub: authenticated_user.id}).token

    if respond_to?(:request)
      request.headers['Authorization'] = "Bearer #{token}"
    else
      header 'Authorization', "Bearer #{token}"
    end
  end
end
