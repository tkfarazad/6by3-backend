# frozen_string_literal: true

namespace :admin do
  resources :users do
    scope module: :users do
      resource :reset_password, only: :create, controller: :reset_password
    end
  end

  resources :videos

  resources :coaches do
    scope module: :coaches do
      concerns :avatarable
    end
  end
end
