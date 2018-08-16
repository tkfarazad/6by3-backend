# frozen_string_literal: true

resource :user, only: %i[show update destroy], controller: :user do
  scope module: :user do
    concerns :avatarable

    resources :tokens, only: :create
  end

  scope module: :user do
    namespace :relationships do
      resources :favorite_coaches,
                only: %i[index create],
                controller: :favorite_coaches

      resource :favorite_coaches,
               only: %i[destroy],
               controller: :favorite_coaches
    end
  end
end
