# frozen_string_literal: true

namespace :admin do
  resources :users do
    delete '' => 'users#destroy_bulk', on: :collection

    scope module: :users do
      resource :reset_password, only: :create, controller: :reset_password
    end
  end

  resources :videos do
    delete '' => 'videos#destroy_bulk', on: :collection

    scope module: :videos do
      resource :thumbnail, only: %i[create update destroy], controller: :thumbnail
    end
  end

  namespace :videos do
    resource :sign, only: %i[show]
  end

  resources :coaches do
    delete '' => 'coaches#destroy_bulk', on: :collection

    scope module: :coaches do
      concerns :avatarable
    end
  end
end
