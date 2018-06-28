# frozen_string_literal: true

namespace :admin do
  resources :users
  resources :coaches do
    scope module: :coaches do
      concerns :avatarable
    end
  end
end
