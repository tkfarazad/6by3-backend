# frozen_string_literal: true

namespace :admin do
  resources :users
  resources :videos
  resources :coaches do
    scope module: :coaches do
      concerns :avatarable
    end
  end
end
