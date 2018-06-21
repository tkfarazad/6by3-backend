# frozen_string_literal: true

resource :user, only: %i[show update destroy], controller: :user do
  scope module: :user do
    resource :avatar, only: %i[create update destroy], controller: :avatar

    resources :tokens, only: :create
  end
end
