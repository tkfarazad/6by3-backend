# frozen_string_literal: true

resource :user, only: %i[show update destroy], controller: :user do
  scope module: :user do
    resources :tokens, only: :create
  end
end
