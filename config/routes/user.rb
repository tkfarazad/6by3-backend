# frozen_string_literal: true

resource :user, only: %i[show], controller: :user do
  scope module: :user do
    resources :tokens, only: :create
  end
end
